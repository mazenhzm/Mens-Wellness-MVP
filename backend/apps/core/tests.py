from types import SimpleNamespace
from unittest.mock import patch

from django.test import SimpleTestCase, override_settings
from rest_framework.exceptions import AuthenticationFailed
from rest_framework.test import APIClient, APIRequestFactory

from apps.core.authentication import ClerkBearerAuthentication
from rest_framework.test import APIClient


@override_settings(SECURE_SSL_REDIRECT=False)
class HealthEndpointTests(SimpleTestCase):
    def setUp(self):
        self.client = APIClient()

    def test_health_check_returns_json_without_database_or_user_data(self):
        response = self.client.get("/api/healthz")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {"status": "ok"})
        self.assertEqual(response["Content-Type"], "application/json")
        self.assertEqual(response["Cache-Control"], "no-store")

    def test_health_check_returns_correlation_id(self):
        response = self.client.get("/api/healthz")

        self.assertEqual(response.status_code, 200)
        self.assertTrue(response["X-Request-ID"])


@override_settings(
    SECURE_SSL_REDIRECT=False,
    CLERK_SECRET_KEY="unit-test-placeholder",
    CLERK_JWT_KEY=None,
    CLERK_AUTHORIZED_PARTIES=[],
)
class ClerkAuthenticationTests(SimpleTestCase):
    def test_clerk_session_is_verified_and_binds_only_provider_subject(self):
        request = APIRequestFactory().get(
            "/api/v1/session",
            HTTP_AUTHORIZATION="Bearer example-session-token",
        )
        state = SimpleNamespace(
            is_signed_in=True,
            payload={
                "sub": "user_test_123",
                "email": "not-copied@example.test",
            },
        )

        with patch(
            "apps.core.authentication.authenticate_request",
            return_value=state,
        ) as verify:
            user, auth_state = ClerkBearerAuthentication().authenticate(request)

        self.assertEqual(user.id, "user_test_123")
        self.assertTrue(user.is_authenticated)
        self.assertFalse(hasattr(user, "payload"))
        self.assertIs(auth_state, state)
        options = verify.call_args.args[1]
        self.assertEqual(options.accepts_token, ["session_token"])
        self.assertIsNone(options.authorized_parties)

    def test_invalid_clerk_token_fails_closed(self):
        request = APIRequestFactory().get(
            "/api/v1/session",
            HTTP_AUTHORIZATION="Bearer invalid-token",
        )

        with (
            patch(
                "apps.core.authentication.authenticate_request",
                return_value=SimpleNamespace(
                    is_signed_in=False,
                    payload={},
                ),
            ),
            self.assertRaises(AuthenticationFailed),
        ):
            ClerkBearerAuthentication().authenticate(request)

    def test_session_endpoint_requires_and_verifies_a_bearer_token(self):
        state = SimpleNamespace(
            is_signed_in=True,
            payload={"sub": "user_test_123"},
        )
        client = APIClient()

        with patch(
            "apps.core.authentication.authenticate_request",
            return_value=state,
        ) as verify:
            response = client.get(
                "/api/v1/session",
                HTTP_AUTHORIZATION="Bearer example-session-token",
            )

        self.assertEqual(response.status_code, 200)
        self.assertEqual(
            response.json(),
            {"authenticated": True, "user_id": "user_test_123"},
        )
        self.assertEqual(
            verify.call_args.args[1].accepts_token,
            ["session_token"],
        )

    def test_session_endpoint_rejects_requests_without_a_token(self):
        response = APIClient().get("/api/v1/session")

        self.assertEqual(response.status_code, 401)

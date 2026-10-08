from django.test import SimpleTestCase, override_settings
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

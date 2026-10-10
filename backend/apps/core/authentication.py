from dataclasses import dataclass

from clerk_backend_api import AuthenticateRequestOptions, authenticate_request
from rest_framework.authentication import (
    BaseAuthentication,
    get_authorization_header,
)
from rest_framework.exceptions import AuthenticationFailed

from django.conf import settings


@dataclass(frozen=True)
class ClerkPrincipal:
    """Minimal request identity; application profile data lives in PostgreSQL."""

    id: str

    @property
    def is_authenticated(self):
        return True

    @property
    def is_anonymous(self):
        return False

    @property
    def is_active(self):
        return True

    def __str__(self):
        return self.id


class ClerkBearerAuthentication(BaseAuthentication):
    """Verify Clerk session tokens through Clerk's maintained Python SDK."""

    def authenticate(self, request):
        header = get_authorization_header(request).split()
        if not header:
            return None
        if len(header) != 2 or header[0].lower() != b"bearer":
            raise AuthenticationFailed("Invalid authentication credentials.")
        if not settings.CLERK_SECRET_KEY:
            raise AuthenticationFailed("Authentication service is unavailable.")

        try:
            state = authenticate_request(
                request,
                AuthenticateRequestOptions(
                    secret_key=settings.CLERK_SECRET_KEY,
                    jwt_key=settings.CLERK_JWT_KEY,
                    authorized_parties=settings.CLERK_AUTHORIZED_PARTIES or None,
                    accepts_token=["session_token"],
                ),
            )
        except Exception:
            # Do not expose SDK, token, network, or claim details to callers.
            raise AuthenticationFailed(
                "Invalid authentication credentials."
            ) from None

        if not state.is_signed_in:
            raise AuthenticationFailed("Invalid authentication credentials.")

        subject = state.payload.get("sub")
        if not isinstance(subject, str) or not subject:
            raise AuthenticationFailed("Invalid authentication credentials.")

        return ClerkPrincipal(id=subject), state

    def authenticate_header(self, request):
        return "Bearer"

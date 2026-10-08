import logging

from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import exception_handler

logger = logging.getLogger("api.errors")

_ERRORS = {
    status.HTTP_400_BAD_REQUEST: ("invalid_request", "The request could not be processed."),
    status.HTTP_401_UNAUTHORIZED: ("authentication_required", "Authentication is required."),
    status.HTTP_403_FORBIDDEN: ("permission_denied", "You do not have permission to do that."),
    status.HTTP_404_NOT_FOUND: ("not_found", "The requested resource was not found."),
    status.HTTP_429_TOO_MANY_REQUESTS: ("rate_limited", "Too many requests. Try again later."),
}


def api_exception_handler(exc, context):
    request = context.get("request")
    request_id = getattr(request, "request_id", None)
    response = exception_handler(exc, context)

    if response is None:
        logger.error("Unhandled API exception", extra={"request_id": request_id})
        code, message = "internal_error", "An unexpected error occurred."
        return Response(
            {"error": {"code": code, "message": message, "requestId": request_id}},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR,
        )

    code, message = _ERRORS.get(
        response.status_code,
        ("request_failed", "The request could not be completed."),
    )
    response.data = {
        "error": {
            "code": code,
            "message": message,
            "requestId": request_id,
        }
    }
    return response

from uuid import uuid4


class RequestIDMiddleware:
    """Add a fresh correlation ID without recording request data."""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        request.request_id = str(uuid4())
        response = self.get_response(request)
        response["X-Request-ID"] = request.request_id
        return response

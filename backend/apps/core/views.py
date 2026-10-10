from drf_spectacular.utils import extend_schema
from rest_framework import serializers
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView


class HealthResponseSerializer(serializers.Serializer):
    status = serializers.ChoiceField(choices=("ok",))


class SessionResponseSerializer(serializers.Serializer):
    authenticated = serializers.BooleanField()
    user_id = serializers.CharField()


class HealthView(APIView):
    authentication_classes = []
    permission_classes = [AllowAny]

    @extend_schema(
        operation_id="healthz",
        summary="Check API availability",
        tags=["Health"],
        responses={200: HealthResponseSerializer},
    )
    def get(self, request):
        return Response(
            {"status": "ok"},
            headers={"Cache-Control": "no-store"},
        )


class SessionView(APIView):
    @extend_schema(
        operation_id="getSession",
        summary="Confirm the authenticated application session",
        tags=["Identity"],
        responses={200: SessionResponseSerializer},
    )
    def get(self, request):
        return Response(
            {
                "authenticated": True,
                "user_id": request.user.id,
            },
            headers={"Cache-Control": "no-store"},
        )

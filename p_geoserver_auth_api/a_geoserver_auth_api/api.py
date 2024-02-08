from .models import Users
from django.db.models import ObjectDoesNotExist
from ninja import NinjaAPI, Header
from django.http import HttpResponse
from base64 import b64decode
from bcrypt import checkpw

api = NinjaAPI()


def check_password(password, hash_postgresql):
    try:
        return checkpw(password.encode("utf-8"), hash_postgresql.encode("utf-8"))
    except ValueError:
        return False


@api.get("/auth")
def add(request, x_http_authorization=Header(alias="X-HTTP-AUTHORIZATION")):
    user, password = b64decode(x_http_authorization).decode("utf-8").split(":")

    try:
        bd_user = Users.objects.get(name=user)

        if user and check_password(password, bd_user.password):
            return HttpResponse(status=200)
        else:
            return HttpResponse(status=401)
    except ObjectDoesNotExist:
        return HttpResponse(status=401)

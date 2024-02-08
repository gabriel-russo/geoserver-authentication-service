from django.db import models
from django.db.models import CharField


class Users(models.Model):
    name = CharField(primary_key=True, max_length=128)
    password = CharField(max_length=254, blank=True, null=True)
    enabled = CharField(max_length=1)

    class Meta:
        managed = False

        db_table = '"geoserver"."users"'

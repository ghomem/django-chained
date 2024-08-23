from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="DJANGO_APPNAME"),
]

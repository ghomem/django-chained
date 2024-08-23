from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("DJANGO_APPNAME/", include("DJANGO_APPNAME.urls")),
    path("accounts/", include("django.contrib.auth.urls")),
    path("admin/", admin.site.urls),
]

from django.contrib import admin
from django.urls import include, path
from django.views.generic.base import TemplateView

urlpatterns = [
    path("DJANGO_APPNAME/", include("DJANGO_APPNAME.urls"), name="DJANGO_APPNAME"),
    path("", TemplateView.as_view(template_name="toplevel.html"), name="toplevel"),
    path("accounts/", include("django.contrib.auth.urls")),
    path("admin/", admin.site.urls),
]

from django.contrib import admin
from django.urls import include, path
from django.views.generic.base import TemplateView
from django.conf import settings

app_name = settings.APP_NAME

urlpatterns = [
    path(f"{app_name}/", include(f"{app_name}.urls")),
    path("", TemplateView.as_view(template_name="toplevel.html"), name="toplevel"),
    path("accounts/", include("django.contrib.auth.urls")),
    path("admin/", admin.site.urls),
]

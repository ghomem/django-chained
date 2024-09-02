from django.contrib import admin
from django.urls import include, path
from django.views.generic.base import TemplateView
from django.conf import settings
import importlib

# get the app name from the settings file
app_name = settings.APP_NAME

# avoid hardcoding the app name by importing dynamically
app_module = importlib.import_module(app_name)

urlpatterns = [
    path("",                 TemplateView.as_view(template_name="toplevel.html"), name="toplevel"),
    path(f"{app_name}/",     include(f"{app_name}.urls")),
    path("accounts/logout/", app_module.views.app_logout),
    path("accounts/",        include("django.contrib.auth.urls")),
    path("admin/",           admin.site.urls, name="admin"),
]

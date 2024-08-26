from django.conf import settings


def get_app_name(request):
    return {
        'APP_NAME': settings.APP_NAME,
    }

def get_app_display_name(request):
    return {
        'APP_NAME': settings.APP_DISPLAY_NAME,
    }

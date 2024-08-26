from django.conf import settings


def get_app_information(request):
    return {
        'APP_NAME': settings.APP_NAME,
        'APP_DISPLAY_NAME': settings.APP_DISPLAY_NAME,
    }

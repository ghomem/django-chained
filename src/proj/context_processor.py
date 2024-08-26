from django.conf import settings

def get_app_name(request):
    return {
        'APP_NAME': settings.APP_NAME,
    }


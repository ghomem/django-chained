from django.conf import settings

def get_appname(request):
    return {
        'APP_NAME': settings.APP_NAME,
    }


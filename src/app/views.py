from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout
from django.shortcuts import render, redirect
from django.conf import settings


def app_logout(request):

    logout(request)

    return redirect(settings.APP_NAME)


@login_required
def index(request):
    return render(request, 'index.html', locals())

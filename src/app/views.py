from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from django.views.generic.base import TemplateView

@login_required
def index(request):
    #return HttpResponse("Hello, world. This is Django.")
    return TemplateView.as_view(template_name="index.html")


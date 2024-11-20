from django.http import Http404
from django.urls import path

from . import views
from config import settings

urlpatterns = [
    path("", views.IndexView.as_view(), name="index"),
]

if settings.DEBUG:
    urlpatterns += [
        path(
            "404/",
            lambda request: views.handler404(request, exception=Http404()),
            name="404",
        ),
    ]

handler404 = "core.views.handler404"

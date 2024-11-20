import logging

from django.shortcuts import render
from django.views.generic import TemplateView

logger = logging.getLogger(__name__)


class IndexView(TemplateView):
    template_name = "core/index.html"

    def get(self, request, *args, **kwargs):
        return render(request, self.template_name)


def handler404(request, exception):
    return render(request, "core/404.html")

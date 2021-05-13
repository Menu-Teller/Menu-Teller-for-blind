from urllib.parse import urlparse

from django.core import serializers
from django.core.serializers import json
from django.http import HttpResponse, response, JsonResponse
from crawlTTS import service


def menu_tts(request):
    shop_type = request.GET.get('shop_type')
    x = request.GET.get('x')
    y = request.GET.get('y')
    radius = request.GET.get('radius')  # todo: post로 변경

    menu_text = service.mapApi(shop_type, x, y, radius)
    data = service.menu_tts(menu_text)
    # data 바탕으로 db 탐색

    return JsonResponse({"voices": data}, safe=False)

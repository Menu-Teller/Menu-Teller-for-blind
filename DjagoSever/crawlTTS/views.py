from urllib.parse import urlparse

from django.core import serializers
import json
from django.http import HttpResponse, response, JsonResponse
from crawlTTS import service


def menu_tts(request):

    if request.method == 'POST':
        body = json.loads(request.body)

        shop_type = body['shop_type']
        x = body['x']
        y = body['y']
        radius = body['radius']

    menu_text = service.mapApi(shop_type, x, y, radius)
    data = service.menu_tts(menu_text)
    # data 바탕으로 db 탐색

    return JsonResponse({"voices": data,
                         "menus": menu_text}, safe=False)

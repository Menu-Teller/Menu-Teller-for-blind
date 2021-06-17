import json
from django.http import JsonResponse
from crawlTTS import crawl, voice


def menu_tts(request):

    if request.method == 'POST':
        body = json.loads(request.body)

        shop_type = body['shop_type']
        x = body['x']
        y = body['y']
        radius = body['radius']

    menu_text = crawl.mapApi(shop_type, x, y, radius)
    if not menu_text:
        # 주변에 음식점 없음.
        return JsonResponse({"voices": "static/wav/scripts/예외음성.wav",
                             "menus": [{"title": "음식점이 없습니다."}]}, safe=False)

    # data 바탕으로 db 탐색
    data = voice.makeOverallVoice(menu_text)

    return JsonResponse({"voices": data,
                         "menus": menu_text}, safe=False)


def get_detail_info(request):
    if request.method == 'GET':
        shop_id = request.GET.get('shop_id')

    data = voice.makeDetailVoice(shop_id)

    if not data:
        return JsonResponse({"voices": "static/wav/scripts/예외음성.wav",
                             "menus": "음식점이 없습니다."}, safe=False)

    return JsonResponse(data, safe=False)

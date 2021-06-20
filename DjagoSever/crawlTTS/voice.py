import crawlTTS.dao as dao
from crawlTTS.tts import kakao_tts


def shopVoice(shop, menu_list):
    # save shop data
    shop_title = shop.get("title") + "  " + shop.get("category") + "가게"  # 카테고리까지 한번에 합성.
    shop_path, shop_duration = kakao_tts(shop_title, "static/wav/shop/")

    shop_id = dao.addShop(shop.get("title"), shop_path, shop_duration,
                          shop.get("category"), menu_list, shop.get("distance"))
    return {"audio_path": shop_path, "duration": shop_duration, "id": shop_id}


def menuVoice(menu_obj):
    if menu_obj.file_url is None:
        path, duration = kakao_tts(menu_obj.title, "static/wav/menu/")
        dao.updateMenu(menu_obj.title, path, duration)
    else:
        path, duration = menu_obj.file_url, menu_obj.duration

    return {"audio_path": path, "duration": duration}


def distanceVoice(dis_obj):

    if dis_obj.file_url is None:
        text = dis_obj.distance + " 미터 이내에 있습니다"
        path, duration = kakao_tts(text, "static/wav/distance/")
        dao.updateDistance(dis_obj.distance, path, duration)
    else:
        path, duration = dis_obj.file_url, dis_obj.duration

    return {"audio_path": path, "duration": duration}


def makeOverallVoice(menu_data):
    overall_voice = []

    for shop in menu_data:
        shop_obj = dao.getShopByTitle(shop.get("title"))
        data = {}
        if shop_obj.exists():
            data["shop"] = {"id": shop_obj[0].id, "audio_path": shop_obj[0].file_url, "duration": shop_obj[0].duration}
        else:
            data["shop"] = shopVoice(shop, [shop.get("menu1"), shop.get("menu2"), shop.get("menu3")])

        overall_voice.append(data)

    return overall_voice


def makeDetailVoice(shop_id):
    detail_data = {}
    idx = 1

    shop_obj = dao.getShopById(shop_id)
    if not shop_obj.exists():
        return detail_data

    detail_data["title"] = {"audio_path": shop_obj[0].file_url, "duration": shop_obj[0].duration}
    for menu_obj in shop_obj[0].menus.all():
        detail_data["menu" + str(idx)] = menuVoice(menu_obj)
        idx += 1

    detail_data["distance"] = distanceVoice(shop_obj[0].distance)

    return detail_data

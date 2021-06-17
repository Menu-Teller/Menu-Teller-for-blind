import requests
import crawlTTS.dao as dao
from mutagen.mp3 import MP3

"""import soundfile
import time
import torch
from espnet_model_zoo.downloader import ModelDownloader
from espnet2.bin.tts_inference import Text2Speech
from parallel_wavegan.utils import download_pretrained_model
from parallel_wavegan.utils import load_model """


def get_duration(audio_path):
    audio = MP3(audio_path)
    duration = audio.info.length

    return round(duration)


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
        return menu_obj.file_url, menu_obj.duration

    return path, duration


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
        path, duration = menuVoice(menu_obj)
        detail_data["menu" + str(idx)] = {"audio_path": path, "duration": duration}
        idx += 1

    #detail_data["distance"] = {"audio_path"}

    return detail_data


def kakao_tts(text, path):
    # 만든 합성기 구동. 우선은 kakao tts로
    headers = {
        # Transfer-Encoding: chunked # 보내는 양을 모를 때 헤더에 포함
        'Host': 'kakaoi-newtone-openapi.kakao.com',
        'Content-Type': 'application/xml',
        'X-DSS-Service': 'DICTATION',
        'Authorization': f'KakaoAK 5e9a09d93f00b8b5c88d5e6cce2bd97f',
    }

    data = "<speak>" + text + "</speak>"
    data = data.encode('utf-8')
    response = requests.post('https://kakaoi-newtone-openapi.kakao.com/v1/synthesize', headers=headers, data=data)

    audio_path = path + text + ".mp3"
    with open(audio_path, "wb+") as mp3:
        mp3.write(response.content)
        duration = get_duration(audio_path)

    return audio_path, duration  # 파일째로 저장하지 않고 경로로 넘겨주기


# espnet tts
"""def espnet_tts(text):
    d = ModelDownloader()
    text2speech = Text2Speech(
        **d.download_and_unpack("/content/tts_tacotron-old.zip"),
        device="cuda",
        # Only for Tacotron 2
        threshold=0.5,
        minlenratio=0.0,
        maxlenratio=10.0,
        use_att_constraint=False,
        backward_window=1,
        forward_window=3,
        # Only for FastSpeech & FastSpeech2
        speed_control_alpha=1.0, )

    with torch.no_grad():
        start = time.time()
        sound, c, *_ = text2speech(text)

    path = "static/wav/"

    with open(path + text + ".wav", "wb+") as wav:
        wav.write(sound)

    return path + text + ".wav" """

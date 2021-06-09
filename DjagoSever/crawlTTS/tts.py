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


def shopVoice(shop):
    # save shop data
    shop_title = shop.get("title") + "가게에 "
    shop_path, shop_duration = kakao_tts(shop_title, "static/wav/shop/")
    dao.addShop(shop_title, shop_path, shop_duration)

    return {"title": {"audio_path": shop_path, "duration": shop_duration}}


def menuVoice(shop, i):
    menu_text = shop.get("menu" + str(i))

    if dao.isExistMenu(menu_text):
        menu_obj = dao.getMenu(menu_text)

        return menu_obj.file_url, menu_obj.duration

    else:
        path, duration = kakao_tts(menu_text, "static/wav/menu/")
        dao.addMenu(menu_text, path, duration)

        return path, duration


def makeMenuVoice(menu_data):
    # isExistMenu로 먼저 탐색, 없으면 addMenu + tts 구동
    # 있으면 해당 db 내용 반환
    voice_data = []

    for shop in menu_data:
        data = shopVoice(shop)

        # make menu voices
        for i in range(1, 4):
            path, duration = menuVoice(shop, i)
            data["menu" + str(i)] = {"audio_path": path,
                                     "duration": duration}

        voice_data.append(data)

    return voice_data


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

import requests
from mutagen.mp3 import MP3

"""import torch
from espnet_model_zoo.downloader import ModelDownloader
from espnet2.bin.tts_inference import Text2Speech"""


def get_duration(audio_path):
    audio = MP3(audio_path)
    duration = audio.info.length

    return round(duration)


def kakao_tts(text, path):
    # 만든 합성기 구동. 우선은 kakao tts로
    headers = {
        # Transfer-Encoding: chunked # 보내는 양을 모를 때 헤더에 포함
        'Host': 'kakaoi-newtone-openapi.kakao.com',
        'Content-Type': 'application/xml',
        'X-DSS-Service': 'DICTATION',
        'Authorization': f'KakaoAK enter your api key',
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
"""def espnet_tts(text, path):
    d = ModelDownloader()
    text2speech = Text2Speech(
        **d.download_and_unpack("static/tts/normal.zip"),
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
        sound, c, *_ = text2speech(text)

    audio_path = path + text + ".mp3"
    with open(audio_path, "wb+") as mp3:
        mp3.write(sound)
        duration = get_duration(audio_path)

    return audio_path, duration  # 파일째로 저장하지 않고 경로로 넘겨주기"""

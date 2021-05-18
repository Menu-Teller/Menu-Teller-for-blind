import tempfile
import wave
from urllib.parse import urlparse

import requests
from django.utils import timezone
from selenium import webdriver

from crawlTTS.models import Menu


def mapApi(shop_type, x, y, radius):
    shop_types = ["FD6", "CE7"]  # 0 - food, 1 - cafe

    url = "https://dapi.kakao.com/v2/local/search/category.json?category_group_code=" + shop_types[int(shop_type)] \
          + "&radius=" + radius + "&y=" + y + "&x=" + x  # 37.550950&x=126.941017"
    result = requests.get(urlparse(url).geturl(),
                          headers={"Authorization": "KakaoAK 5e9a09d93f00b8b5c88d5e6cce2bd97f"})  # 본인 api 키 입력

    json_obj = result.json()
    market_list = json_obj.get("documents")

    data = crawlMenu(market_list)  # crawlTTS menu and make text

    return data


def crawlMenu(market_list):
    options = webdriver.ChromeOptions()
    # 창 숨기는 옵션 추가
    options.add_argument("headless")
    driver = webdriver.Chrome(executable_path=r'C:\Users\may05\PycharmProjects\chromedriver.exe',
                              options=options)  # 본인 크롬 드라이버 위치 입력
    data = []
    market_idx = 1

    for market in market_list:
        text = {}
        menu_idx = 1
        idx = 1

        text["title"] = market.get("place_name")
        driver.get(market.get("place_url"))
        driver.implicitly_wait(3)

        try:
            menu_list = driver.find_element_by_class_name("list_menu")
            menu_list = menu_list.find_elements_by_class_name("loss_word")

            for i in menu_list:
                text["menu" + str(idx)] = i.text
                menu_idx += 1
                idx += 1

                if menu_idx > 3:
                    break  # 일단 메뉴 3개만

            data.append(text)

            market_idx += 1

            if market_idx > 5:
                break  # 일단 음식점 5개만

        except:
            continue

    return data


def isExistMenu(text):
    menu_obj = Menu.objects.filter(title=text)

    if menu_obj.exists():
        return True

    return False


def addMenu(text, path):
    instance = Menu.objects.create(title=text, created_at=timezone.now(), file_url=path)
    instance.save()

    return


def getMenu(text):
    return Menu.objects.get(title=text)


def menu_tts(menu_data):
    # isExistMenu로 먼저 탐색, 없으면 addMenu + tts 구동
    # 있으면 해당 db 내용 반환
    voice_data = []

    for shop in menu_data:
        data = {"title": tts(shop.get("title") + "가게에 ")}

        for i in range(1, 4):
            menu_text = shop.get("menu" + str(i))

            if isExistMenu(menu_text):
                data["menu" + str(i)] = getMenu(menu_text).file_url
            else:
                path = tts(menu_text)
                data["menu" + str(i)] = path
                addMenu(menu_text, path)

        data["end"] = tts("메뉴가 있습니다.")

        voice_data.append(data)

    return voice_data


def tts(text):
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

    voice = response.content
    path = "static/wav/"

    with open(path + text + ".wav", "wb+") as wav:
        wav.write(response.content)

    return path + text + ".wav"  # 파일째로 저장하지 않고 경로로 넘겨주기

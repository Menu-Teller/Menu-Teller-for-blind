from urllib.parse import urlparse

from django.contrib.sites import requests
from selenium.webdriver.chrome import webdriver

from crawl.models import Menu


def crawl(shop_type, x, y, radius):
    shop_types = ["FD6", "CE7"] # 0 - food, 1 - cafe

    url = "https://dapi.kakao.com/v2/local/search/category.json?category_group_code=" + shop_types[shop_type] \
          + "&radius=" + str(radius) + "&y=" + y + "&x=" + x  # 37.550950&x=126.941017"
    result = requests.get(urlparse(url).geturl(),
                          headers={"Authorization": "KakaoAK 00000"})  # 본인 api 키 입력
    driver = webdriver.Chrome(executable_path=r'C:\Users\may05\PycharmProjects\chromedriver.exe')  # 본인 크롬 드라이버 위치 입력
    driver.implicitly_wait(3)

    json_obj = result.json()
    market_list = json_obj.get("documents")
    data = {}
    idx = 1

    for market in market_list:
        driver.get(market.get("place_url"))
        try:
            menu_list = driver.find_element_by_class_name("list_menu").find_elements_by_class_name("loss_word")
            for i in menu_list:
                data["menu" + str(idx)] = i.text
        # 에러 처리 안되어있어서 조금만 class name 바뀌면 에러남. 나중에 시간나면 고칠 예정
        except:
            break

    return data


def isExistMenu(text):
    menu_list = Menu.objects.all()
    menu_obj = menu_list.filter(title=text)

    if menu_obj is None:
        return False

    return True


def addMenu(text, path):
    instance = Menu.objects.create(titel=text, file_url=path)
    instance.save()

    return


def menu_tts(data):
    # isExistMenu로 먼저 탐색, 없으면 addMenu + tts 구동
    # 있으면 해당 db 내용 반환

    # todo: 받은 data list 적절히 파싱해서 함수들 돌리기
    return data


def tts(text):
    # 만든 합성기 구동. 우선은 kakao tts로
    headers = {
            # Transfer-Encoding: chunked # 보내는 양을 모를 때 헤더에 포함
            'Host': 'kakaoi-newtone-openapi.kakao.com',
            'Content-Type': 'application/xml',
            'X-DSS-Service': 'DICTATION',
            'Authorization': f'KakaoAK 00000000000',
        }

    data = "<speak>" + text + "</speak>"
    data = data.encode('utf-8')
    response = requests.post('https://kakaoi-newtone-openapi.kakao.com/v1/synthesize', headers=headers, data=data)

    voice = response.content
    path = "/static/wav/"

    with open(path + text + ".mp3", "wb+") as mp3:
        mp3.write(voice)

    return path + text + ".mp3"

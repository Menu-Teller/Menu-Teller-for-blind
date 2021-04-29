from urllib.parse import urlparse

from django.core import serializers
from pip._vendor import requests
from django.core.serializers import json
from django.http import HttpResponse, response, JsonResponse
from django.shortcuts import render

# Create your views here.
from selenium import webdriver


def crawl(request):
    """headers = {
        # Transfer-Encoding: chunked # 보내는 양을 모를 때 헤더에 포함
        'Host': 'kakaoi-newtone-openapi.kakao.com',
        'Content-Type': 'application/xml',
        'X-DSS-Service': 'DICTATION',
        'Authorization': f'KakaoAK 00000000000',
    } """
    shop_types = ["FD6", "CE7"]

    shop_type = int(request.GET.get('shop_type'))  # 0 - food, 1 - cafe
    x = request.GET.get('x')
    y = request.GET.get('y')
    radius = 350  # 필요에 따라 주변 범위 지정

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

    print(data)
    return HttpResponse(data)

from selenium import webdriver
from urllib.parse import urlparse
import requests


def mapApi(shop_type, x, y, radius):
    shop_types = ["FD6", "CE7"]  # 0 - food, 1 - cafe

    url = "https://dapi.kakao.com/v2/local/search/category.json?category_group_code=" + shop_types[int(shop_type)] \
          + "&radius=" + radius + "&y=" + y + "&x=" + x + "&sort=distance"
    result = requests.get(urlparse(url).geturl(),
                          headers={"Authorization": "KakaoAK 5e9a09d93f00b8b5c88d5e6cce2bd97f"})

    json_obj = result.json()
    market_list = json_obj.get("documents")

    data = crawlMenu(market_list)  # crawl menu and make text

    return data


def setChromeOptions():
    options = webdriver.ChromeOptions()
    # 창 숨기는 옵션 추가
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument("--single-process")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--remote-debugging-port=9222")  # solve error "DevToolsActivePort file doesn't exist"

    return options


def crawlMenu(market_list):
    driver = webdriver.Chrome(executable_path=r'static/driver/chromedriver.exe',
                              options=setChromeOptions())  # 본인 크롬 드라이버 위치 입력
    data = []
    market_idx = 1

    for market in market_list:
        menu_idx = 1

        driver.get(market.get("place_url"))
        driver.implicitly_wait(3)

        try:
            menu_list = driver.find_element_by_class_name("list_menu")
            menu_list = menu_list.find_elements_by_class_name("loss_word")

            text = {"title": market.get("place_name"), "distance": market.get("distance"),
                    "category": market.get("category_name").split('>')[1].strip()}
            for i in menu_list:
                text["menu" + str(menu_idx)] = i.text
                menu_idx += 1

                if menu_idx > 3:
                    break  # 메뉴 3개

            data.append(text)
            market_idx += 1

            if market_idx > 4:
                break  # 음식점 4개

        except:
            continue

    return data

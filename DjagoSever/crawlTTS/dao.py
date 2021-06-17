from crawlTTS.models import Menu, Shop
from django.utils import timezone


def isExistMenu(text):
    menu_obj = Menu.objects.filter(title=text)

    if menu_obj.exists():
        return True

    return False


def addMenu(text):
    instance = Menu.objects.create(title=text, created_at=timezone.now())
    instance.save()

    return instance


def updateMenu(text, path, duration):
    instance = getMenu(text)[0]
    instance.file_url = path
    instance.duration = duration
    instance.save()


def getMenu(text):
    return Menu.objects.filter(title=text)


def getShopByTitle(text):
    return Shop.objects.filter(title=text)


def getShopById(shop_id):
    return Shop.objects.filter(id=shop_id)


def addShop(text, path, duration, category, menus, distance):
    instance = Shop.objects.create(title=text, created_at=timezone.now(), category=category,
                                   file_url=path, duration=duration, distance=distance)

    for menu in menus:
        menu_obj = getMenu(menu)
        if menu_obj.exists():
            instance.menus.add(menu_obj)
        else:
            instance.menus.add(addMenu(menu))
    instance.save()

    return instance.id



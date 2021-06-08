from crawlTTS.models import Menu, Shop
from django.utils import timezone


def isExistMenu(text):
    menu_obj = Menu.objects.filter(title=text)

    if menu_obj.exists():
        return True

    return False


def addMenu(text, path):
    instance = Menu.objects.create(title=text, created_at=timezone.now(), file_url=path)
    instance.save()


def getMenu(text):
    return Menu.objects.get(title=text)


def addShop(text, path):
    instance = Shop.objects.create(title=text, file_url=path)
    instance.save()



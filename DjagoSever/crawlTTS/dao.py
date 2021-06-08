from crawlTTS.models import Menu, Shop
from django.utils import timezone


def isExistMenu(text):
    menu_obj = Menu.objects.filter(title=text)

    if menu_obj.exists():
        return True

    return False


def addMenu(text, path, duration):
    instance = Menu.objects.create(title=text, created_at=timezone.now(), file_url=path, duration=duration)
    instance.save()


def getMenu(text):
    return Menu.objects.get(title=text)


def addShop(text, path, duration):
    instance = Shop.objects.create(title=text, file_url=path, duration=duration)
    instance.save()



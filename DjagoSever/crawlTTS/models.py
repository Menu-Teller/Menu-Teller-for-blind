from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models


# Create your models here.


class Menu(models.Model):
    # 메뉴 이름, wav 파일 db
    title = models.CharField(max_length=50, default='')
    created_at = models.DateTimeField(auto_now_add=True, null=True)
    file_url = models.URLField(max_length=200, blank=True, null=True, default='')
    duration = models.PositiveIntegerField(default=3, validators=[MinValueValidator(1), MaxValueValidator(100)])


class Shop(models.Model):
    # 기본 스크립트는 항상 사용하므로 db 없이 그냥 고정된 경로로 접근
    # 하지만 음식점 이름은 매번 바뀌기에 저장을 따로 해야 할 것 같음.
    # 그리고 같은 음식점을 다시 만날 확률이 적을 것으로 판단되어 메뉴보다 더 자주 데이터 날리기 해야할 듯.
    title = models.TextField(max_length=200)
    file_url = models.URLField(max_length=200, blank=True, null=True, default='')
    duration = models.PositiveIntegerField(default=3, validators=[MinValueValidator(1), MaxValueValidator(100)])

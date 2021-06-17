from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models


class Menu(models.Model):
    # 메뉴 이름, wav 파일 db
    title = models.TextField(max_length=50, default='')
    created_at = models.DateTimeField(auto_now_add=True, null=True)
    file_url = models.URLField(max_length=200, blank=True, null=True, default='')
    duration = models.PositiveIntegerField(default=3, validators=[MinValueValidator(1), MaxValueValidator(100)])


class Shop(models.Model):
    # 메뉴 이름과 many-to-many 관계.
    title = models.TextField(max_length=50, default='')
    created_at = models.DateTimeField(auto_now_add=True, null=True)
    file_url = models.URLField(max_length=200, blank=True, null=True, default='')
    duration = models.PositiveIntegerField(default=3, validators=[MinValueValidator(1), MaxValueValidator(100)])
    # menu와 관계 매핑
    menus = models.ManyToManyField(Menu)

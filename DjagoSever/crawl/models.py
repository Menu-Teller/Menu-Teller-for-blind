from django.db import models

# Create your models here.


class Menu(models.Model):
    # 메뉴 이름, wav 파일 db
    title = models.CharField(max_length=50, default='')
    created_at = models.DateTimeField(auto_now_add=True, null=True)
    file_url = models.URLField(max_length=200, blank=True, null=True, default='')


class Scripts(models.Model):
    # 기본 스크립트 db
    text = models.TextField(max_length=200)
    file_url = models.URLField(max_length=200, blank=True, null=True, default='')

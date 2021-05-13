# Menu Teller for Blind

해당 branch 구현 기능

위치 기반 메뉴 크롤링, 합성용 스크립트 생성, 데이터베이스 관리, 메뉴 텍스트와 음성 전달

request: POST 메소드로 아래와 같이 json 전달
```
{
  "shop_type": "0", -- 0 = 음식점, 1 = 카페
  "x": "00",
  "y": "00",
  "radius": "00" -- 주변 범위
} 
```
- [ ] **현재는 GET 메소드로 parameter로 받는중. 변경 필요.** 



response: 음성 파일 경로를 반환. 필요 시 다른 형식으로 변경될 수 있음.
```
{
    "voices": [
        {
            "title": "static/wav/도꼭지가게에 .wav",
            "menu1": "static/wav/고등어구이+계절솥밥 (런치).wav",
            "menu2": "static/wav/삼치구이+계절솥밥 (런치).wav",
            "menu3": "static/wav/제주산갈치구이+계절솥밥 (런치).wav",
            "end": "static/wav/메뉴가 있습니다..wav"
        },
        {
            "title": "static/wav/원조기사님분식가게에 .wav",
            "menu1": "static/wav/짜장.wav",
            "menu2": "static/wav/우동.wav",
            "menu3": "static/wav/오뎅백반.wav",
            "end": "static/wav/메뉴가 있습니다..wav"
        },
        {
            "title": "static/wav/양조주택가게에 .wav",
            "menu1": "static/wav/부추무침 알리오올리오.wav",
            "menu2": "static/wav/이태리 통닭.wav",
            "menu3": "static/wav/짚불 돼지구이.wav",
            "end": "static/wav/메뉴가 있습니다..wav"
        },
        {
            "title": "static/wav/서강곱창가게에 .wav",
            "menu1": "static/wav/야채곱창 (1인).wav",
            "menu2": "static/wav/알곱창 (1인).wav",
            "menu3": "static/wav/순대곱창 (1인).wav",
            "end": "static/wav/메뉴가 있습니다..wav"
        },
        {
            "title": "static/wav/티키타코가게에 .wav",
            "menu1": "static/wav/2인 세트 1.wav",
            "menu2": "static/wav/2인 세트 2.wav",
            "menu3": "static/wav/1인 세트.wav",
            "end": "static/wav/메뉴가 있습니다..wav"
        }
    ]
}
```

총 5개의 가게와 해당 가게의 메뉴를 3개씩 반환.

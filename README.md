# Menu Teller for Blind

### Client

Front App을 구현함.  
`dio` 라이브러리로 Django Server에 Post request를 보내고  
Menus 데이터와 tts로 변환된 파일의 path를 받아옴.  

파일의 path를 `audioplayer` 라이브러리로 출력. 이때 각 audio 사이에 delay를 줌.

Django Server에 request를 보낼 때, `Google Map Location`으로 위도 및 경도를 보냄.

audio를 출력할 때는 "voices" 데이터를 받고,  
menulist를 출력할 때는 "menus" 데이터를 받음.

**앞으로 해야 할 일**
* 크롤링이 되지 않은 상태를 처리   
방법 1. App이 켜지고 크롤링이 다 될 때까지 로딩하는 창을 만듦.  
방법 2. Null 값이 들어갔을 때 오류를 출력하는 log를 출력하도록 만듦.  

* UI 바꾸기  
* TTS 가 제대로 작동하면, 바로 소리 test 들어가기  


### Server

위치 기반 메뉴 크롤링, 합성용 스크립트 생성, 데이터베이스 관리, 메뉴 텍스트와 음성 전달  
client로 부터 위치 정보를 post로 받아 이를 이용해 kakao map api 사용.   
주변 가게 url을 받아 크롤링하여 메뉴 정보 추출.   
추출한 텍스트를 바탕으로 음성 합성 -> 현재 만든 음성합성기의 성능이 낮아 우선은 kakao tts로 합성   
만들어진 음성을 static에 저장하고 해당 경로를 반환.     

매번 음성합성하는 것은 비효율적이므로, 데이터베이스에 저장해 같은 메뉴는 다시 합성하지 않도록 구현.

request: POST 메소드로 아래와 같이 위치 정보 json 전달
```
{
  "shop_type": "0", -- 0 = 음식점, 1 = 카페
  "x": "00",
  "y": "00",
  "radius": "00" -- 주변 범위
} 
```
- [X] **현재는 GET 메소드로 parameter로 받는중. 변경필요. -> 변경 완료** 


response: 합성한 음성 파일 경로와 음식점, 메뉴 리스트를 반환.   
필요 시 다른 형식으로 변경될 수 있음.   
아래와 같은 형식이며, 우선는 5개의 가게와 각 3개 메뉴를 보내줌.
```
{
    "voices": [
        {
            "title": "static/wav/도꼭지.wav",
            "menu1": "static/wav/고등어구이+계절솥밥 (런치).wav",
            "menu2": "static/wav/삼치구이+계절솥밥 (런치).wav",
            "menu3": "static/wav/제주산갈치구이+계절솥밥 (런치).wav",
            "end": "static/wav/메뉴가 있습니다..wav"
        },
        {
            "title": "static/wav/원조기사님분식.wav",
            "menu1": "static/wav/짜장.wav",
            "menu2": "static/wav/우동.wav",
            "menu3": "static/wav/오뎅백반.wav",
            "end": "static/wav/메뉴가 있습니다..wav"
        }
    ],
    "menus": [
        {
            "title": "도꼭지",
            "menu1": "고등어구이+계절솥밥 (런치)",
            "menu2": "삼치구이+계절솥밥 (런치)",
            "menu3": "제주산갈치구이+계절솥밥 (런치)",
        },
        {
            "title": "원조기사님분식",
            "menu1": "짜장",
            "menu2": "우동",
            "menu3": "오뎅백반",
        }
    ]
}
```

**앞으로 해야 할 일**
-[ ] espnet이 장고에서 동작하는지 확인
-[ ] heroku 혹은 aws ec2를 리서치해서 배포
-[ ] 테스트 코드 작성
-[ ] 하나로 몰아져있는 코드 리팩토링

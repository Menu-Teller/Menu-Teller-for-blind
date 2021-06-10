# Menu Teller for Blind

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
   
**0608 수정**   
앱에서 매끄러운 음성 연결을 위해 음성 파일 길이 실어서 response.   
원래 wav로 저장하였으나, wav 음성 길이 측정 시 64bit wav를 못 여는 에러 발생.   
=> mp3의 용량이 더 작지만 음성 품질은 차이가 별로 없고, 길이 측정이 용이하여 mp3로 변경   
   
또한, 예외음성, 마무리멘트, 로딩멘트 등은 항상 같으므로 db 없이 static 폴더에 항상 있음.   
경로와 duration이 항상 같으니 바로 접근.   
```
{
    "voices": [
        {
            "title": {
                "audio_path": "static/wav/shop/도꼭지가게에 .mp3",
                "duration": 1
            },
            "menu1": {
                "audio_path": "static/wav/menu/고등어구이+계절솥밥 (런치).mp3",
                "duration": 2
            },
            "menu2": {
                "audio_path": "static/wav/menu/삼치구이+계절솥밥 (런치).mp3",
                "duration": 2
            },
            "menu3": {
                "audio_path": "static/wav/menu/제주산갈치구이+계절솥밥 (런치).mp3",
                "duration": 3
            }
        }
    ],
    "menus": [
        {
            "title": "도꼭지",
            "menu1": "고등어구이+계절솥밥 (런치)",
            "menu2": "삼치구이+계절솥밥 (런치)",
            "menu3": "제주산갈치구이+계절솥밥 (런치)"
        }
    ]
}
```
   
음식점 없을 시 response
```
{
    "voices": "static/wav/scripts/예외음성.wav",
    "menus": "음식점이 없습니다."
}
```
   
**앞으로 해야 할 일**    

- [ ] espnet이 장고에서 동작하는지 확인
- [ ] heroku 혹은 aws ec2를 리서치해서 배포
- [ ] 테스트 코드 작성
- [X] 하나로 몰아져있는 코드 리팩토링
- [ ] 파이썬 장고 스타일 코드 구조 개선

<<<<<<< HEAD
# Menu Teller TTS

## **음식점 메뉴 중심의 한국어 음성 합성기**

본 Text-to-Speech 오픈 소스는 외래어 메뉴 이름에 대해 합성 품질을 개선하기 위해 시작되었습니다. 

 - [ESPnet2 오픈소스](https://github.com/espnet/espnet/tree/master/egs2)의 FastSpeech2 모델을 사용함
 - 학습용 전용 Corpus가 있음
 
## Recipes Used

[ESPnet2 오픈소스](https://github.com/espnet/espnet/tree/master/egs2) 중 새 레시피 제작용 [TTS TAMPLATE](https://github.com/espnet/espnet/tree/master/egs2/TEMPLATE/tts1)를 기반으로 제작되었습니다. FastSpeech2 모델의 학습 방법은 [이 링크](https://github.com/espnet/espnet/tree/master/egs2/TEMPLATE/tts1#fastspeech2-training)를 참조하십시오.

## Training Corpus

메뉴 중심의 한국어 음성 합성기를 훈련하기 위해 13000문장으로 이루어진 Corpus를 구성하였습니다.

 - 3000개의 메뉴 문장
 - 10000개의 일상어 문장

현재까지 녹음된 3780개 문장의 Corpus는 [이 링크](https://drive.google.com/open?id=18jsV3JNoq8r3HfwZzlP4KxdvMEKKRlNe)에서 확인할 수 있습니다.

## How to Use

### Pre-required
Please install **ESPnet** and **Kaldi**

### How to Train the Model

 1. menu-tts\downloads에 [학습용 Corpus](https://drive.google.com/open?id=18jsV3JNoq8r3HfwZzlP4KxdvMEKKRlNe)를 넣는다.
 2. FastSpeech2 모델의 학습을 진행한다.
 
## Reference
[ESPnet2 오픈소스](https://github.com/espnet/espnet/tree/master/egs2)
=======
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
방법 1. App이 켜지고 크롤링이 다 될 때까지 로딩하는 창을 만듦. (아마 이 방법으로 해야 할 듯)
방법 2. Null 값이 들어갔을 때 오류를 출력하는 log를 출력하도록 만듦.  

* UI 바꾸기  
* TTS 가 제대로 작동하면, 바로 소리 test 들어가기 _해결_

**0608 수정**
* Menu TTS 에서 Chrome driver 오류 발생 시 대처
1. [chromedriver version update](https://ddolcat.tistory.com/846)
2. [DevToolsActivePort file doesn't exist](https://gmyankee.tistory.com/240)  
이 service.py에 코드 추가  
`options.add_argument("--remote-debugging-port=9222")`

* Flutter 오류 발생 시 대처
1. [recompling 시 .gradle 삭제](https://stackoverflow.com/questions/59893018/flutter-execution-failed-for-task-appcompiledebugkotlin)
2. [flutter version update](https://github.com/flutter/flutter/issues/83834)

* chromedriver 경로 설정
/status/driver이었는데, static이 ignore 처리되어 있어서 들어가지 않음.  
또한 chromedriver의 버전이 각 컴퓨터 마다 다름  
어차피 Linux에서 돌릴 꺼니까 상관 없을 듯

* MenuTTS service.py 의 menu_tts에서 title 다음과 같이 바꿈
`data = {"title": kakao_tts(shop.get("title")+"가게에 ")}`  
**가게에** 가 들어있지 않았음.

* audio player delay 설정을 5초에서 3초정도로 바꿈
**문제점**  
빠른 delay다 보니 중간에 오디오가 끝까지 못 말하고 끊기기도 함.  
flutter에 오디오 시간을 받아오는 모듈 함수가 없음😭  
가끔씩 location 받아오기 전에 http response를 보내서 에러가 발생  
delay 조절하기  

[참고할 flutter 앱의 android 배포 링크](https://here4you.tistory.com/198)

**일시적 데모**
![ezgif com-gif-maker](https://user-images.githubusercontent.com/51294226/121154899-4b538300-c882-11eb-9355-caa98e0b2532.gif)


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

-[ ] espnet이 장고에서 동작하는지 확인
-[ ] heroku 혹은 aws ec2를 리서치해서 배포
-[ ] 테스트 코드 작성
-[ ] 하나로 몰아져있는 코드 리팩토링
>>>>>>> 30ad497e4e19505c5ba3614876ccd071c9b8ca23

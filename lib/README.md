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
* loading 하는 창에 오디오 넣기
* tutorial 창에 오디오 넣기
* List View 꾸미기
* 버튼마다 오디오 나오게 하기 (그리고 비동기식 처리 중지하는 법 조사)

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

**0615 수정**
* UI 수정
1. 페이지 1 (init Page)
2. 페이지 2 (Tutorial Page)
3. 페이지 3 (Button Page)
4. 페이지 4 (Menu List)
* 페이지 1에서 tab을 두번 치면 바로 페이지 3으로 넘어감. 한번 치면 페이지 2로 넘어감
* 로딩 창을 만듦.

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

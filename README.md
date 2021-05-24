# Menu Teller for Blind

DongJun branch

해당 branch 에서는 Front App을 구현함.  
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

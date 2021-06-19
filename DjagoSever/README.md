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

**0617 수정**  
한번에 보내는 것에서 -> 처음엔 음식점 이름과 카테고리만 불러줌  
-> 이후 해당 음식점 id로 다시 요청오면 디테일한 정보를 보내도록 수정
```
{
    "voices": [
        {
            "shop": {
                "audio_path": "static/wav/shop/샐러디 서강대학교점  패스트푸드가게.mp3",
                "duration": 3,
                "id": 1
            }
        },
        {
            "shop": {
                "audio_path": "static/wav/shop/밀플랜비 서강대점  패스트푸드가게.mp3",
                "duration": 3,
                "id": 2
            }
        }
    ],
    "menus": [
        {
            "title": "샐러디 서강대학교점",
            "distance": "107",
            "category": "패스트푸드",
            "menu1": "칠리베이컨 웜볼",
            "menu2": "시저치킨 샐러디",
            "menu3": "콥 샐러디"
        },
        {
            "title": "밀플랜비 서강대점",
            "distance": "163",
            "category": "패스트푸드",
            "menu1": "소고기 라이스 부리또",
            "menu2": "소고기 감자 부리또",
            "menu3": "소고기 베이컨 라이스 부리또"
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
     
음식점 버튼 request는 GET/ detail?shop_id= 에 음식점 id를 넣어 요청   
=> url 이름이 안이뻐서.. 수정할수도   

자세한 음식점 정보 Response      
```
{
    "title": {
        "audio_path": "static/wav/shop/샐러디 서강대학교점  패스트푸드가게.mp3",
        "duration": 3
    },
    "menu1": {
        "audio_path": "static/wav/menu/칠리베이컨 웜볼.mp3",
        "duration": 2
    },
    "menu2": {
        "audio_path": "static/wav/menu/시저치킨 샐러디.mp3",
        "duration": 2
    },
    "menu3": {
        "audio_path": "static/wav/menu/콥 샐러디.mp3",
        "duration": 1
    },
    "distance": {
        "audio_path": "static/wav/distance/107 미터 이내에 있습니다.mp3",
        "duration": 2
    }
}
```   

**앞으로 해야 할 일**    

- [X] espnet이 장고에서 동작하는지 확인 -> install error.. colab에서만 돌아가는 것으로 보아 다른 package와 매우 충돌나는 듯...
- [X] heroku 혹은 aws ec2를 리서치해서 배포 -> 실패..   
    heroku = 크롤링까지 배포 완료. But, heroku 자체가 파일 저장을 막는다고 함.    
    우리가 짠 코드상으로는 mp3 파일을 db에 넣을 수 없어 파일 자체 저장해야 하는데, 여기서 저장을 못해서 실패   
    aws ec2 = 크롤링에서 막힘. chrome driver를 linux용으로 변경해 크롤링 자체는 돌아가지만, 무슨 이유인지 driver.get을 하면 하얀 화면만 나오는 에러.   
    이때문에 noSuchElement 에러가 계속 발생해 데이터를 제대로 못 가져옴 --> 가장 해결해볼만한 문제지만 시간 부족으로 우선 실패..   
    pythonanywhere = 크롤링을 자체 지원하지만, 문제는 whitelist에 등록된 사이트만 제대로 크롤링 할 수 있도록 막아놓았다고 한다.    
    무분별한 auto system을 막겠다고 하는데.. 이때문에 실패   
       
    -> 시간이 일주일만 더 있었다면 ec2 관련해서 더 찾아볼 수 있었을 듯 하다. 셀레니움 쓰는게 우리만은 아닐테니..   
- [ ] 테스트 코드 작성
- [X] 하나로 몰아져있는 코드 리팩토링
- [ ] 파이썬 장고 스타일 코드 구조 개선

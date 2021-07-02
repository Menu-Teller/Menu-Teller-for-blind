## 🔊 **Menu-Teller**

<img src="https://user-images.githubusercontent.com/37532204/124210673-d42ea900-db26-11eb-8096-51ef9e6f7a9f.png" width="200" height="200"/>

지도 앱을 보고 사용하는데 상대적으로 어려움이 있는 시각 장애인들을 위한, 주변 음식점 정보 음성 제공 서비스. 

### ➰ **프로젝트 흐름**

앱을 실행 후 버튼을 누르면 사용자의 위치 정보가 서버로 넘어옵니다.
서버는 위치 정보를 받은 후 kakao map api를 사용하여 주변 음식점 정보를 얻고, 이를 이용해 크롤링하여 각 음식점의 세부 정보(메뉴, 위치 등)을 얻습니다.
이러한 세부 정보를 음성 합성기를 이용하여 상황에 따라 알맞게 합성합니다.
합성한 음성을 앱으로 보내 사용자가 들을 수 있도록 합니다.
시각 장애인들을 위해 앱의 UI는 최대한 간단하게 구현합니다.

![Menu-Teller ReadMe c3e73a6a99fc435e9d05b5dd3f33fadf](https://user-images.githubusercontent.com/37532204/124210720-e7417900-db26-11eb-88ad-54917382f2fb.png)

### 📅 팀원 소개 및 일정

<img src="https://user-images.githubusercontent.com/37532204/124210756-f6c0c200-db26-11eb-84a5-9c5fbb91df84.png" width="800" height="400"/>

### 🛠 **기술 스택**

![Menu-Teller ReadMe c3e73a6a99fc435e9d05b5dd3f33fadf 2](https://user-images.githubusercontent.com/37532204/124210785-fd4f3980-db26-11eb-91d6-aba14784b7ef.png)

### 📌 핵심 기술

**TTS**

저희만의 음성 합성기를 새롭게 만듭니다. 기존 음성 합성기는 외래어에 관하여 약간의 부자연스러움이 있었고, 음식 메뉴는 외래어가 매우 많기에 음식 메뉴에 초점을 맞춘 음성 합성기를 새로 개발합니다.

<img src="https://user-images.githubusercontent.com/37532204/124210807-09d39200-db27-11eb-8103-5045c12e9181.png" width="150" height="300"/>

<img src="https://user-images.githubusercontent.com/37532204/124210822-10620980-db27-11eb-9e1c-3e971d8cf8c0.png" width="350" height="300"/><img src="https://user-images.githubusercontent.com/37532204/124210831-135cfa00-db27-11eb-8863-2b3f8ee14d4b.png" width="350" height="300"/>

teacher 모델에서 얻은 단순화 데이터 대신, ground-truth recordings으로 모델을 직접 훈련하며 pitch, energy 등의 더 다양한 정보를 학습하여 합성 속도 및 음성 품질을 높인 fastspeech2 모델 선정.

메뉴 문장과 일반 문장으로 이루어진 특수한 문장 코퍼스 구성.
이를 phoneme으로 변환 후 kaldi 형식 dir 구성. 이후 espnet 오픈소스를 이용하여 tacotron2 모델로 pre training. 이후 tacotron2의 결과를 활용하여 fastspeech2 모델 학습.

<img src="https://user-images.githubusercontent.com/37532204/124210845-1e178f00-db27-11eb-811e-b6f3bac787e4.png" width="400" height="400"/><img src="https://user-images.githubusercontent.com/37532204/124210855-22dc4300-db27-11eb-8618-79b2828ceaed.png" width="400" height="400"/>

왼쪽: 3780 문장 훈련 / 오른쪽: 8000 문장 훈련

현재 녹음이 3780개만 완료되어 해당 음성으로만 학습한 합성기는 왼쪽 결과처럼 loss 값이 크고 줄어들지 않는 문제 발생. 이를 확실히 하기 위해, 학습 문장이 많은 일반 문장 코퍼스([https://www.kaggle.com/bryanpark/korean-single-speaker-speech-dataset](https://www.kaggle.com/bryanpark/korean-single-speaker-speech-dataset)) 를 학습한 결과 loss가 크게 줄어들었으며 음성 합성 또한 잘되는 것을 확인.
⇒ 그러므로 구성한 메뉴 + 일반 문장인 저희 코퍼스의 녹음이 완료되어 전부 학습할 수 있다면 좋은 음성 품질이 나올 것으로 예상.

**Server**

<img src="https://user-images.githubusercontent.com/37532204/124210874-2b347e00-db27-11eb-816c-2913a642835a.png" width="450" height="400"/><img src="https://user-images.githubusercontent.com/37532204/124210882-2ec80500-db27-11eb-841c-017e4d5e05a5.png" width="450" height="400"/>

서버 구조는 다음과 같으며, 데이터베이스에 이미 합성한 정보들을 저장하여 중복 합성을 피하도록 한다. 
[자세한 server 정보](https://github.com/Menu-Teller/Menu-Teller-for-blind/tree/master/DjagoSever)

**Front**

앱은 flutter를 이용해 구현하며 비동기식 처리를 진행. 
delay를 음성 파일 duration에 맞춰 걸어주어 음성 중복을 피하고 메뉴 정보를 받아 리스트 형태로 출력.   
[자세한 client 정보](https://github.com/Menu-Teller/Menu-Teller-for-blind/tree/master/lib)

![Menu-Teller ReadMe c3e73a6a99fc435e9d05b5dd3f33fadf 3](https://user-images.githubusercontent.com/37532204/124210917-3d162100-db27-11eb-826d-0f5ca59ffc85.png)

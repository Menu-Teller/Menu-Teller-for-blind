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

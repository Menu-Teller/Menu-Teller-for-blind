import 'package:flutter/material.dart';
import 'main.dart';

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPage createState() => _TutorialPage();
}

class _TutorialPage extends State<TutorialPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
        ),
        home: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(200.0),
            child: Container(
              padding: EdgeInsets.only(top: 30),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset('assets/images/speech_icon-removebg.png')
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                          "Menu Teller",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 30.0,
                            color: Colors.black,
                          ))
                    )

                  ]
              )
            )
          ),
          body: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    )
                );
              },
              child: Column(
                children: <Widget>[
                  Align(
                    alignment:Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                      child: Text(
                        "Tutorial",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 60,
                        )
                      )
                    )
                  ),
                  Align(
                      alignment:Alignment.topCenter,
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                              "시각 장애인을 위한\n메뉴 읽어주기 서비스\n\n"
                              "탭을 왼쪽으로 넘기면\n메뉴 리스트를 확인할 수 있으며, \n\n"
                                  "위를 누르면 현재 자신의 위치정보를 변경하고 "
                                  "음식점을 읽어드립니다.\n\n"
                                  "아래 4개 버튼은 음식점 순서대로 \n"
                                  "음식점과의 거리를 알려주고 \n"
                                  "해당 음식점의 음식점 메뉴를 읽습니다.\n\n"
                              "튜토리얼을 모두 들으셨다면 \n화면을 눌러주세요.",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'NotoSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              )
                          )
                      )
                  )
                ],
              )
          ),
        )
    );
  }
}
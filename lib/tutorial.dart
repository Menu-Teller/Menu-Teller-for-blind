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
                              "?????? ???????????? ??????\n?????? ???????????? ?????????\n\n"
                              "?????? ???????????? ?????????\n?????? ???????????? ????????? ??? ?????????, \n\n"
                                  "?????? ????????? ?????? ????????? ??????????????? ???????????? "
                                  "???????????? ??????????????????.\n\n"
                                  "?????? 4??? ????????? ????????? ???????????? \n"
                                  "??????????????? ????????? ???????????? \n"
                                  "?????? ???????????? ????????? ????????? ????????????.\n\n"
                              "??????????????? ?????? ??????????????? \n????????? ???????????????.",
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
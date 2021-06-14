import 'package:flutter/material.dart';
import 'tutorial.dart';
import 'main.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Menu Teller",
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home : InitPage(),
    );
  }
}

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(300.0),
          child: Center(
              child: Column(
                  children: <Widget> [
                    Spacer(),
                    SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/images/speech_icon-removebg.png')
                    ),
                    Text(
                        "Menu Teller",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 30.0,
                          color: Colors.black,
                        ))
                  ]
              )
          ),
        ),
        body: Column(
          children: [
            GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutorialPage(),
                      )
                  );
                },
                onDoubleTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(),
                      )
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(150),
                  decoration: BoxDecoration(
                    //border: Border.all(),
                      color: Colors.white
                  ),
                )
            ),
            Spacer(),
            Container(
                child : Text(
                  "Please Tab if you want to Start!",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                padding : EdgeInsets.only(bottom: 60)
            )

          ],
        )
    );
  }
}
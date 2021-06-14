import 'package:flutter/material.dart';

import 'speechbutton.dart';
import 'menulist.dart';

void main() {
  runApp(MyApp());
}

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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120.0),
            child: AppBar(
                backgroundColor: Colors.grey[500],
                bottom: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(icon: Icon(Icons.radio)),
                    Tab(icon: Icon(Icons.fastfood)),
                  ],
                ),
                title: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "Menu Teller",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ),
            ),
          ),
          body: TabBarView(children: [
            SpeechMenuButton(),
            MenuList(),
          ]),
        ),
      ),
    );
  }
}
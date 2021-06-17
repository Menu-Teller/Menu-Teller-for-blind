import 'package:flutter/material.dart';
import 'speechbutton.dart';
import 'menulist.dart';
import 'init.dart';

void main() {
  runApp(MyApp());
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
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';  // Add this line.
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

const _API_PREFIX = "http://10.0.2.2:8000/menuTTS/";
class Server {
  Future<void> getReq() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get("$_API_PREFIX");
    print(response.data.toString());
  }

  Future<void> postReq(Map<String, dynamic> data) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post("$_API_PREFIX", data: data);
    print(response.data.toString());
  }
}

Server server = Server();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Menu Teller for the Blind",
      home : MainPage(),
    );
  }
}

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    //return Text(wordPair.asPascalCase);
    return Scaffold (
      appBar: AppBar(
        title: Text('주변 식당 List'),
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }
  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
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
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.radio)),
                Tab(icon: Icon(Icons.fastfood)),
              ],
            ),
            title: Text("Menu Teller Demo")
          ),
          body: TabBarView(children: [
            TextExample(),
            MenuList(),
          ]),
        ),
      ),
    );
  }
}

class TextExample extends StatefulWidget {
  @override
  _TextExampleState createState() => _TextExampleState();
}

class _TextExampleState extends State<TextExample> {
  String _buttonState='OFF';
  var _color=Colors.red;
  Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    data = {
      "shop_type":"0",
      "x": position.latitude.toString(),
      "y": position.longitude.toString(),
      "radius": "100"
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: RaisedButton(
                child: Text('$_buttonState',style: TextStyle(fontSize: 30),),
                onPressed: (){
                  server.postReq(data);
                  //server.getReq();
                  changeText();
                  },
                color: _color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void changeText(){
    setState(() {
      if(_buttonState=='OFF'){
        _buttonState='ON';
        _color=Colors.blue;
      }

      else{
        _buttonState='OFF';
        _color=Colors.red;
      }
    });
  }
}

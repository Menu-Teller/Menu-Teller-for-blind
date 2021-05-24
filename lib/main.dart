import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';  // Add this line.
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';

const _API_PREFIX = "http://10.0.2.2:8000/menuTTS/";
const _API_AUDIO_PREFIX = "http://10.0.2.2:8000/";
class Server {
  Future<void> getReq() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get("$_API_PREFIX");
    print(response.data.toString());
  }

  Future<Map<String, dynamic>> postReq(Map<String, dynamic> data) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post("$_API_PREFIX", data: data);
    return response.data;
  }
}
/*
class Voice {
  final List<dynamic> voice;
  //final twoDMenu = List.generate(voice.length, (i) => List(5), growable: false);
  Voice({this.voice});
  List list;
  factory Voice.fromJson(Map<String, dynamic> json) {
    return Voice(
      voice: json['voices'] as List,
    );
  }
}
*/
/*
class Menus {
  final twoDMenu;
  Menus({this.twoDMenu});
  factory Menus.fromList(List<dynamic> voice) {
    var twoDList = List.generate(voice.length, (i) => List(5), growable: false);
    for (int i=0;i<voice.length;i++){
      twoDList[i][0] = voice[i]["title"];
      twoDList[i][1] = voice[i]["menu1"];
      twoDList[i][2] = voice[i]["menu2"];
      twoDList[i][3] = voice[i]["menu3"];
      twoDList[i][4] = voice[i]["end"];
    }
    return Menus(
      twoDMenu: twoDList,
    );
  }
}
*/

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
            SpeechMenuButton(),
            MenuList(),
          ]),
        ),
      ),
    );
  }
}

class SpeechMenuButton extends StatefulWidget {
  @override
  _SpeechMenuButton createState() => _SpeechMenuButton();
}

class _SpeechMenuButton extends State<SpeechMenuButton> {
  String _buttonState='OFF';
  var _color=Colors.red;
  Map<String, dynamic> data;
  AudioPlayer audioPlayer = AudioPlayer();
  List<dynamic> pathlist1 = List.filled(0,0,growable:true);
  List<dynamic> pathlist2 = List.filled(0,0,growable:true);
  Map<String, dynamic> json;

  @override
  void initState() {
    super.initState();
    AudioPlayer.logEnabled = false;
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
              width: 300,
              height: 300,
              child: FlatButton(
                child: Text("Update Location", style: TextStyle(fontSize: 22, color: Colors.white)),
                onPressed: (){
                  getCurrentLocation();
                  Future.delayed(Duration(milliseconds: 5000), (){
                    getReq();
                  });
                },
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 300,
              height: 300,
              child: RaisedButton(
                child: Text('$_buttonState',style: TextStyle(fontSize: 30),),
                onPressed: (){
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
        getAudio();
        _buttonState='OFF';
        _color=Colors.red;
      }
    });
  }

  void getReq() async{
    json = await server.postReq(data);
    print(json["voices"]);
    print(json["menus"]);
  }

  void getAudio() async{
    var url = _API_AUDIO_PREFIX;

    for(int i=0;i<json["voices"].length;i++){
      getDelay("title", i, 1);
      getDelay("menu1", i, 2);
      getDelay("menu2", i, 3);
      getDelay("menu3", i, 4);
      getDelay("end", i, 5);
      pathlist2.add(pathlist1);
      pathlist1 = List.filled(0,0,growable:true);
    }
  }

  void getDelay(var name, int i, int name_i) async{
    var path = _API_AUDIO_PREFIX + json["voices"][i][name];
    pathlist1.add(path);
    int duration = (i+1) * name_i * 5000;
    Future.delayed(Duration(milliseconds: duration), (){
      print(path);
      playAudio(pathlist2[i][name_i]);
      print(pathlist2[i][name_i]);
    });
  }

  Future<void> playAudio(var url) async {
    int result = await audioPlayer.play(url);
    if (result == 1){
      print("success");
    } else {
      print("fail");
    }
    //duration = await audioPlayer.getDuration();
  }
}

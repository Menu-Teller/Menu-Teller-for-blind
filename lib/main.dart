import 'package:flutter/material.dart';
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

Server server = Server();
Map<String, dynamic> json;
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

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {

  @override
  void initState() {
    super.initState();
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
    return ListView.separated(
        padding: EdgeInsets.all(5),
        itemCount : json["menus"].length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height:50,
            color: Colors.amber[100],
            child: RaisedButton(
              child: Text('${json["menus"][index]["title"]}'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuDetail(index: index)),
                );
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class MenuDetail extends StatelessWidget {
  final int index;
  MenuDetail({Key key, @required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu List'),
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions() {
    return ListView.separated(
      padding: EdgeInsets.all(3),
      itemCount : json["menus"].length - 2,
      itemBuilder: (BuildContext context, int i) {
        return Container(
          height:50,
          color: Colors.amber[100],
          child: Center(
            child: Text('${json["menus"][index]["menu${i+1}"]}'),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
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

  @override
  void initState() {
    super.initState();
    AudioPlayer.logEnabled = false;
    getCurrentLocation();
    Future.delayed(Duration(milliseconds: 5000), (){
      getReq();
    });
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
              child: RaisedButton(
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
      getDelay("title", i, 0);
      getDelay("menu1", i, 1);
      getDelay("menu2", i, 2);
      getDelay("menu3", i, 3);
      getDelay("end", i, 4);
      pathlist2.add(pathlist1);
      pathlist1 = List.filled(0,0,growable:true);
    }
  }

  void getDelay(var name, int i, int name_i) async{
    var path = _API_AUDIO_PREFIX + json["voices"][i][name];
    int delaySec = 3000;
    pathlist1.add(path);
    int duration = name_i * delaySec + delaySec * 5 * i;
    print(json["voices"][i][name]);
    print(duration);
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

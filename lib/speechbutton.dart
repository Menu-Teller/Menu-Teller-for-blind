import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'http.dart';
const _API_AUDIO_PREFIX = "http://10.0.2.2:8000/";

class SpeechMenuButton extends StatefulWidget {
  @override
  _SpeechMenuButton createState() => _SpeechMenuButton();
}

class _SpeechMenuButton extends State<SpeechMenuButton> {
  var _color=Colors.white;
  Map<String, dynamic> data;
  AudioPlayer audioPlayer = AudioPlayer();
  List<dynamic> pathlist1 = List.filled(0,0,growable:true);

  int _duration = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showDialog(5);
      AudioPlayer.logEnabled = false;
      getCurrentLocation();
      Future.delayed(Duration(milliseconds: 5000), () {
        postReq();
      });
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
              Material(
                child: InkWell(
                  child: Container(
                    width: 350,
                    height: 130,
                    child: Center(
                      child: Text("Update Location",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: Colors.white
                            )),
                    ),
                    decoration: new BoxDecoration(
                        color: Colors.black,
                        border: Border.all(width: 1),
                        borderRadius: const BorderRadius.all(const Radius.circular(40))
                    ),
                  ),
                  onTap: (){
                    _showDialog(10);
                    getCurrentLocation();
                      Future.delayed(Duration(milliseconds: 5000), (){
                        postReq();
                      });
                    Future.delayed(Duration(milliseconds: 18000), (){
                      getAudioShop();
                    });
                  },
                ),
              ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 175,
                  height: 200,
                  child: RaisedButton(
                    child: Text('Restaurant 1',style: TextStyle(fontSize: 25),),
                    onPressed: (){
                      getAudio("1");
                    },
                    color: _color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 175,
                  height: 200,
                  child: RaisedButton(
                    child: Text('Restaurant 2',style: TextStyle(fontSize: 25),),
                    onPressed: (){
                      getAudio("2");
                      //changeText("2");
                    },
                    color: _color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 175,
                  height: 200,
                  child: RaisedButton(
                    child: Text('Restaurant 3',style: TextStyle(fontSize: 25),),
                    onPressed: (){
                      getAudio("3");
                      //changeText("3");
                    },
                    color: _color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 175,
                  height: 200,
                  child: RaisedButton(
                    child: Text('Restaurant 4',style: TextStyle(fontSize: 25),),
                    onPressed: (){
                      getAudio("4");
                      //changeText("4");
                    },
                    color: _color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void postReq() async{
    json = await server.postReq(data);
    print(json["voices"]);
    print(json["menus"]);
  }

  void getAudioShop() async{
    var url = _API_AUDIO_PREFIX;
    _duration = 0;
    print("if it is success?");
    print(json);
    pathlist1 = List.filled(0,0,growable:true);
    for(int i=0;i<json["voices"].length;i++){
      getDelay("audio_path", i);
    }
  }

  void getAudio(var i) async{
    json = await server.getReq(i);
    print(json);
    var url = _API_AUDIO_PREFIX;
    Future.delayed(Duration(milliseconds: 1000), (){
      _duration = 0;
      print("if it is success?");
      print(json);
      getDelayDetail("title");
      getDelayDetail("menu1");
      getDelayDetail("menu2");
      getDelayDetail("menu3");
      getDelayDetail("distance");
    });
  }

  void getDelayDetail(var name) async{
    var path = _API_AUDIO_PREFIX + json[name]["audio_path"];
    if (name == "title"){
      _duration = 0;
    } else {
      _duration += json[name]["duration"] * 1000 + 1000;
    }
    print(_duration);
    Future.delayed(Duration(milliseconds: _duration), (){
      print(path);
      playAudio(path);
      print(path);
    });
  }

  void getDelay(var name, int i) async{
    var path = _API_AUDIO_PREFIX + json["voices"][i]["shop"][name];
    pathlist1.add(path);
    _duration += json["voices"][i]["shop"]["duration"] * 1000 + 1000;
    print(json["voices"][i]["shop"][name]);
    print(_duration);
    Future.delayed(Duration(milliseconds: _duration), (){
      print(path);
      playAudio(pathlist1[i]);
      print(pathlist1[i]);
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

  void _showDialog(int seconds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        Future.delayed(Duration(seconds: seconds), () {
          Navigator.pop(context);
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
          ),
          content: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child:
                      new CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation(Colors.blue),
                          strokeWidth: 5.0
                      ),
                      height: 50.0,
                      width: 50.0,
                    ),
                    SizedBox(height: 50),
                    Text("Loading, Please Wait."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
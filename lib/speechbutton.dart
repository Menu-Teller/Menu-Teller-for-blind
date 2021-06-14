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
  String _buttonState='Start Speech';
  var _color=Colors.white;
  Map<String, dynamic> data;
  AudioPlayer audioPlayer = AudioPlayer();
  List<dynamic> pathlist1 = List.filled(0,0,growable:true);
  List<dynamic> pathlist2 = List.filled(0,0,growable:true);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showDialog();
      AudioPlayer.logEnabled = false;
      getCurrentLocation();
      Future.delayed(Duration(milliseconds: 5000), () {
        getReq();
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
            Container(
              width: 350,
              height: 100,
              child: RaisedButton(
                child: Text("Update Location", style: TextStyle(fontSize: 22, color: Colors.white)),
                onPressed: (){
                  _showDialog();
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
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 175,
                  height: 200,
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
                SizedBox(width: 10),
                Container(
                  width: 175,
                  height: 200,
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 175,
                  height: 200,
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
                SizedBox(width: 10),
                Container(
                  width: 175,
                  height: 200,
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
          ],
        ),
      ),
    );
  }
  void changeText(){
    setState(() {
      if(_buttonState=='Stop'){
        _buttonState='Start Speech';
        _color=Colors.white;
      }

      else{
        getAudio();
        _buttonState='Stop';
        _color=Colors.white24;
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

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        Future.delayed(Duration(seconds: 5), () {
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
import 'package:dio/dio.dart';
const _API_PREFIX = "http://10.0.2.2:8000/menuTTS/";


Server server = Server();
Map<String, dynamic> json;

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
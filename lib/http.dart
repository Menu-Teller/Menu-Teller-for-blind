import 'package:dio/dio.dart';
const _API_PREFIX = "http://10.0.2.2:8000/menuTTS/";
const _API_PREFIX_DETAIL = "http://10.0.2.2:8000/detail";


Server server = Server();
Map<String, dynamic> json;

class Server {
  Future<Map<String, dynamic>> getReq(var i) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get("$_API_PREFIX_DETAIL"+"?shop_id="+i);
    return response.data;
  }

  Future<Map<String, dynamic>> postReq(Map<String, dynamic> data) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post("$_API_PREFIX", data: data);
    return response.data;
  }
}
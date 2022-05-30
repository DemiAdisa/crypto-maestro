

import 'package:dio/dio.dart';
import 'package:flutter_learning/models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService
{
  final Dio dioInstance = Dio();

  AppConfig? _appConfig;
  String? _baseUrl;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseUrl = _appConfig!.COIN_API_BASE_URL;
    print(_baseUrl);
  }

  Future<Response?> get(String _path) async {

    try{
      String _url = "$_baseUrl$_path";
      return await dioInstance.get(_url);

    }catch (exception){
      print("HTTPService Says Unable to Perform Get Request");
      print(exception);
    }
  }
}
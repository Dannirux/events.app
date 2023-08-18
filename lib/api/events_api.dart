import 'dart:io';

import 'package:dio/dio.dart';

class EventsApi {
  static final Dio _dio = Dio();

  static void configureDio() {
    ///Base url
    _dio.options.baseUrl = 'http://ec2-44-211-205-218.compute-1.amazonaws.com:3003/';
    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
    };
  }

  static Future<Response> get(String path, [Map<String, dynamic> queryParameters = const {}]) async {
      Response response = await _dio.get(path, queryParameters: queryParameters);
      return response;
  }

  static Future<Response> post(String path, dynamic data) async {
      Response response = await _dio.post(path, data: data);
      return response;
  }
  static Future<Response> put(String path, dynamic data) async {
    Response response = await _dio.put(path, data: data);
    return response;
  }


}
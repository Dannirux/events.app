import 'dart:io';

import 'package:dio/dio.dart';

class EventsApi {
  static final Dio _dio = Dio();

  static void configureDio() {
    ///Base url
    _dio.options.baseUrl = 'http://ec2-3-83-46-123.compute-1.amazonaws.com:3003';
    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
    };
  }


}
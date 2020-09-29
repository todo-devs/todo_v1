import 'dart:convert';
import 'dart:developer';

import 'package:device_proxy/device_proxy.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class DownloadUssdService {
  Future<String> fetchHash() async {
    var dio = await _getDio();
    var response = await dio.get(
        'https://todo-devs.github.io/todo-json/hash.json',
        options: Options(headers: {'Accept-Encoding': 'gzip, deflate, br'}));

    if (response.statusCode == 200) {
      var body = response.data as Map<String, dynamic>;

      return json.encode(body);
    } else {
      throw Exception(
        'Request failed: ${response.request.uri}\n'
        'StatusCode: ${response.statusCode}\n'
        'Body: ${response.data}',
      );
    }
  }

  Future<String> fetchUssdConfig() async {
    var dio = await _getDio();
    log('test');
    var response = await dio.get(
        'https://todo-devs.github.io/todo-json/config.json',
        options: Options(headers: {'Accept-Encoding': 'gzip, deflate, br'}));

    if (response.statusCode == 200) {
      var body = response.data as Map<String, dynamic>;

      return json.encode(body);
    } else {
      throw Exception(
        'Request failed: ${response.request.uri}\n'
        'StatusCode: ${response.statusCode}\n'
        'Body: ${response.data}',
      );
    }
  }

  Future<Dio> _getDio() async {
    ProxyConfig proxyConfig = await DeviceProxy.proxyConfig;
    var dio = Dio();
    if (proxyConfig.isEnable) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          return "PROXY ${proxyConfig.proxyUrl};";
        };
        client.connectionTimeout = Duration(seconds: 10);
      };
    }
    return dio;
  }
}

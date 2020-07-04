import 'dart:convert';

import 'package:http/http.dart' as http;

class DownloadUssdService {
  Future<String> fetchHash() async {
    final resp = await http.get(
      'https://todo-devs.github.io/todo-json/hash.json',
      headers: {
        'Accept-Encoding': 'gzip, deflate, br',
      },
    );
    if (resp.statusCode == 200) {
      var json = jsonDecode(resp.body);
      var hash = json['hash'];
      return hash;
    } else {
      throw Exception(
        'Request failed: ${resp.request.url}\n'
        'StatusCode: ${resp.statusCode}\n'
        'Body: ${resp.body}',
      );
    }
  }

  Future<String> fetchUssdConfig() async {
    final resp = await http.get(
      'https://todo-devs.github.io/todo-json/config.json',
      headers: {
        'Accept-Encoding': 'gzip, deflate, br',
      },
    );
    if (resp.statusCode == 200) {
      var body = utf8.decode(resp.bodyBytes);

      return body;
    } else {
      throw Exception(
        'Request failed: ${resp.request.url}\n'
        'StatusCode: ${resp.statusCode}\n'
        'Body: ${resp.body}',
      );
    }
  }
}

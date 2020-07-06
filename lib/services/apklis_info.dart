import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:todo/models/apklis_info.dart';

class ApklisService {
  final packageName = "com.cubanopensource.todo";
  Future<ApklisInfo> fetchApklisInfo() async {
    final resp = await http.get(
      'https://api.apklis.cu/v2/application/?package_name=$packageName',
    );
    if (resp.statusCode == 200) {
      var jsonResponse = jsonDecode(resp.body);
      List<dynamic> data = jsonResponse['results'];
      ApklisInfo apklisInfo = ApklisInfo.fromJson(data[0]);

      return apklisInfo;
    } else {
      throw Exception(
        'Request failed: ${resp.request.url}\n'
        'StatusCode: ${resp.statusCode}\n'
        'Body: ${resp.body}',
      );
    }
  }
}

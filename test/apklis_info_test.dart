import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:todo/services/apklis_info.dart';

main() {
  group("Obtiene info sobre Apklis", () {
    test("Retorna las configuraciones del fichero json", () async {
      var apklisService = ApklisService();
      var apklisInfo = await apklisService.fetchApklisInfo();
      SharedPreferences.setMockInitialValues(
          {"apklisInfo": json.encode(apklisInfo.toJson())});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('apklisInfo', json.encode(apklisInfo.toJson()));
      var apkI = json.decode(prefs.get("apklisInfo"));

      expect("com.cubanopensource.todo", apkI["package_name"]);
      expect("v1.2.2", apkI["version_name"]);
    });
  });
}

import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:todo/models/apklis_info.dart';
import 'package:todo/services/apklis_info.dart';

import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

Future<ApklisInfo> fetchApklisInfoMock(http.Client client) async {
  final packageName = "com.cubanopensource.todo";

  final response = await client
      .get('https://api.apklis.cu/v2/application/?package_name=$packageName');

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    List<dynamic> data = jsonResponse['results'];
    ApklisInfo apklisInfo = ApklisInfo.fromJson(data[0]);
    // Si la llamada al servidor fue exitosa, analice el JSON
    return apklisInfo;
  } else {
    // Si esa llamada no fue exitosa, lance un error.
    throw Exception('Error al cargar post');
  }
}

main() {
  group("Obtiene info sobre Apklis", () {
    // test("Retorna las configuraciones del fichero json", () async {
    //   var apklisService = ApklisService();
    //   var apklisInfo = await apklisService.fetchApklisInfo();

    //   SharedPreferences.setMockInitialValues(
    //       {"apklisInfo": json.encode(apklisInfo.toJson())});
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString('apklisInfo', json.encode(apklisInfo.toJson()));
    //   var apkI = json.decode(prefs.get("apklisInfo"));

    //   expect("com.cubanopensource.todo", apkI['package_name']);
    //   expect("v1.2.2", apkI['version_name']);
    // });

    test("Mock Apklis Response", () async {
      final packageName = "com.cubanopensource.todo";

      final client = MockClient();

      // Usa Mockito para devolver una respuesta exitosa cuando llama al
      // http.Client proporcionado.
      when(client.get(
              'https://api.apklis.cu/v2/application/?package_name=$packageName'))
          .thenAnswer((_) async => http.Response(RESPONSE_APKLIS, 200));
      var apklisInfo = await fetchApklisInfoMock(client);
      prints(apklisInfo);
      expect(await fetchApklisInfoMock(client), isA<ApklisInfo>());
    });
  });
}

const RESPONSE_APKLIS = """
{
    "count": 1,
    "next": null,
    "previous": null,
    "facets": {},
    "results": [
        {
            "package_name": "com.cubanopensource.todo",
            "name": "TODO",
            "video_url": "",
            "video_img": "",
            "description": "<p>TODO es una aplicación de código abierto creada por un grupo de desarrolladores cubanos: https://github.com/todo-devs/ con el objetivo de facilitar el acceso a los servicios de ETECSA. Permite ejecutar los códigos ussd destinados para acceder a distintos servicios de la compañía además de gestionar el inicio de sesión en el portal nauta de WIFI_ETECSA y Nauta Hogar.</p>",
            "updated": "2020-07-01T14:28:19.325788+00:00",
            "price": 0.0,
            "rating": 4.0,
            "sponsored": 0,
            "public": true,
            "with_db": false,
            "deleted": false,
            "download_count": 27327,
            "reviews_star_1": 6,
            "reviews_star_2": 3,
            "reviews_star_3": 2,
            "reviews_star_4": 7,
            "reviews_star_5": 26,
            "releases_count": 4,
            "reviews_count": 44,
            "categories": [
                {
                    "id": 1,
                    "name": "Cuba",
                    "icon": "cubans",
                    "group": "Applications",
                    "icon_url": "https://archive.apklis.cu/category/Aplicaciones_y_juegos_cubanos.png"
                },
                {
                    "id": 3,
                    "name": "Utilidades",
                    "icon": "utils",
                    "group": "Applications",
                    "icon_url": "https://archive.apklis.cu/category/Utilidades_b48JMjB.png"
                },
                {
                    "id": 8,
                    "name": "Herramientas",
                    "icon": "tools",
                    "group": "Applications",
                    "icon_url": "https://archive.apklis.cu/category/Herramientas_y_utilidades_nUE9z86.png"
                },
                {
                    "id": 50,
                    "name": "Internet",
                    "icon": "internet",
                    "group": "Applications",
                    "icon_url": "https://archive.apklis.cu/category/Internet_feq0fhU.png"
                }
            ],
            "developer": {
                "username": "correaleyval",
                "first_name": "Luis",
                "last_name": "Correa Leyva",
                "fullname": "Luis Correa Leyva",
                "avatar": "https://archive.apklis.cu/user/avatar/6625254811193938982_IGqzTsY.png",
                "background": null,
                "apps": 1,
                "is_active": true,
                "description": ""
            },
            "last_release": {
                "abi": [
                    {
                        "abi": "armeabi-v7a"
                    }
                ],
                "no_abi": false,
                "version_name": "v1.2.2",
                "package_name": "com.cubanopensource.todo",
                "app_name": "TODO",
                "version_sdk_name": "Jelly Bean 4.1.x",
                "version_target_sdk_name": "Pie 9.0",
                "permissions": [
                    {
                        "icon": "",
                        "description": "",
                        "name": "Access network state"
                    },
                    {
                        "icon": "",
                        "description": "",
                        "name": "Access wifi state"
                    },
                    {
                        "icon": "",
                        "description": "",
                        "name": "Call phone"
                    },
                    {
                        "icon": "",
                        "description": "",
                        "name": "Internet"
                    }
                ],
                "screenshots": [
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/1_DEtiLnk.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/2_SwjV1ZU.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/3_Z5Gat3j.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/4_xUO19rF.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/5_rBCW4Yx.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/6_ydFjo3u.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/7_zgB1qqm.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/8_ZwUGKNi.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/9_broL4Am.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/10_G7D80EA.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/11_8rXWyrs.jpg"
                    },
                    {
                        "description": "",
                        "img": "https://archive.apklis.cu/application/screenshot/12_V2PXoYY.jpg"
                    }
                ],
                "changelog": "<p>TODO v1.2.2 llega con un ligero cambio en el diseño para mejorar la experiencia del usuario y un nuevo módulo para gestionar las cuentas de navegación nauta con la posibilidad de guardar sus cuentas y conectarse facilmente.</p>",
                "version_code": 8,
                "published": "2020-07-01T14:28:19.325788Z",
                "sha256": "1c635389c11e2309bcb8f40bc3d827a4c2f1b51c79d1ec6e418bcfdf991031fd",
                "size": "7.09 MB",
                "icon": "https://archive.apklis.cu/application/icon/com.cubanopensource.todo-v8.png",
                "public": true,
                "beta": false,
                "version_sdk": "Jelly Bean 4.1.x",
                "version_target_sdk": "Pie 9.0",
                "deleted": false
            },
            "announced": false
        }
    ]
}
""";

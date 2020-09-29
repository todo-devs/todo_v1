import 'dart:developer';
import 'dart:io';

import 'package:apklis_api/apklis_api.dart';
import 'package:apklis_api/models/apklis_item_model.dart';
import 'package:device_proxy/device_proxy.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:package_info/package_info.dart';
import 'package:todo/pages/update_page.dart';

class CheckUpdatePage extends StatefulWidget {
  @override
  CheckUpdatePageState createState() => CheckUpdatePageState();
}

class CheckUpdatePageState extends State<CheckUpdatePage> {
  var loading = true;
  var message = '';
  var buttonText = 'CANCELAR COMPROBACIÓN';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1500));
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
    ApklisItemModel apklisItemModel;
    try {
      if (Platform.isAndroid) {
        final packageInfo = await PackageInfo.fromPlatform();
        final packageName = packageInfo.packageName;
        var apklisApi = ApklisApi(packageName, dioClient: dio);
        var model = await apklisApi.get();
        if (model.isOk && (model.result?.results?.length ?? 0) > 0) {
          apklisItemModel = model.result.results.first;
        }
      }
    } catch (e) {
      log(e);
    }
    if (apklisItemModel != null) {
      final packageInfo = await PackageInfo.fromPlatform();
      var actual = int.tryParse(packageInfo.buildNumber);
      var last = apklisItemModel.lastRelease.versionCode;
      if ((actual != null && last != null && actual < last)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UpdatePage(model: apklisItemModel),
          ),
        );
      } else {
        setState(() {
          loading = false;
          message = 'Comprobación exitosa.\n\n'
              'Tiene la última versión de la aplicación.\n\n';
          buttonText = 'CERRAR';
        });
      }
    } else {
      setState(() {
        loading = false;
        message =
            'Ha ocurrido un error en la comprobación de la actualización de la aplicación.\n\n'
            'Revise su conexión e inténtelo nuevamente.\n\n'
            'Si el error continúa póngase en contacto con el equipo de desarrollo.';
        buttonText = 'CERRAR';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Actualización',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: loading
                    ? Platform.isAndroid
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : CupertinoActivityIndicator()
                    : Container(
                        margin: EdgeInsets.all(30),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: GFColors.SUCCESS,
                minWidth: MediaQuery.of(context).size.width,
                elevation: 0.5,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

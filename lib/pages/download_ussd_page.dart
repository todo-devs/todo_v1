import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/ussd_codes.dart';
import 'package:todo/pages/home_page.dart';
import 'package:todo/services/download_ussd.dart';
import 'package:todo/themes/colors.dart';

class DownloadUssdPage extends StatefulWidget {
  @override
  _DownloadUssdPageState createState() => _DownloadUssdPageState();
}

class _DownloadUssdPageState extends State<DownloadUssdPage> {
  var loading = true;
  var message = '';
  var buttonText = 'CANCELAR DESCARGA';
  var ussdService = DownloadUssdService();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1500));
    try {
      var prefs = await SharedPreferences.getInstance();
      var lastHash = prefs.getString('hash');
      var actualDay = DateTime.now().day;
      var actualHash = await ussdService.fetchHash();
      if (actualHash != lastHash) {
        var body = await ussdService.fetchUssdConfig();
        var parsedJson = jsonDecode(body);
        UssdRoot.fromJson(parsedJson);
        prefs.setString('hash', actualHash);
        prefs.setString('config', body);
        setState(() {
          loading = false;
          message = 'Comprobación exitosa.\n\n'
              'Se han actualizado los códigos USSD.\n\n';
          buttonText = 'CERRAR';
        });
      } else {
        setState(() {
          loading = false;
          message = 'Comprobación exitosa.\n\n'
              'No hay cambios en los códigos USSD.\n\n';
          buttonText = 'CERRAR';
        });
      }
      prefs.setInt('day', actualDay);
    } catch (e) {
      log(e.toString());
      setState(() {
        loading = false;
        message = 'Ha ocurrido un error en la descarga de los códigos USSD.\n\n'
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
          'Descarga',
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
                        ? CircularProgressIndicator()
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(title: 'TODO'),
                    ),
                  );
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

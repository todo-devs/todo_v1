import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/ussd_codes.dart';
import 'package:todo/pages/home_page.dart';
import 'package:todo/themes/colors.dart';

class DownloadUssdPage extends StatefulWidget {
  @override
  _DownloadUssdPageState createState() => _DownloadUssdPageState();
}

class _DownloadUssdPageState extends State<DownloadUssdPage> {
  var loading = true;
  var message = '';
  var buttonText = 'CANCELAR DESCARGA';

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
      var resp = await get(
        'https://todo-devs.github.io/todo-json/hash.json',
        headers: {
          'Accept-Encoding': 'gzip, deflate, br',
        },
      );
      if (resp.statusCode == 200) {
        var json = jsonDecode(utf8.decode(resp.bodyBytes));
        var actualHash = json['hash'];
        if (actualHash != lastHash) {
          var resp = await get(
            'https://todo-devs.github.io/todo-json/config.json',
            headers: {
              'Accept-Encoding': 'gzip, deflate, br',
            },
          );
          if (resp.statusCode == 200) {
            var body = utf8.decode(resp.bodyBytes);
            var parsedJson = jsonDecode(body);
            UssdRoot.fromJson(parsedJson);
            prefs.setString('hash', actualHash);
            prefs.setString('config', body);
          } else {
            throw Exception(
              'Request failed: ${resp.request.url}\n'
              'StatusCode: ${resp.statusCode}\n'
              'Body: ${resp.body}',
            );
          }
        }
        prefs.setInt('day', actualDay);
      } else {
        throw Exception(
          'Request failed: ${resp.request.url}\n'
          'StatusCode: ${resp.statusCode}\n'
          'Body: ${resp.body}',
        );
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(title: 'TODO')),
      );
    } catch (e) {
      log(e.toString());
      setState(() {
        loading = false;
        message = 'Ha ocurrido un error en la descarga de los códigos USSD.\n\n'
            'Revise su conexión e intentelo nuevamente.\n\n'
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
                    ? CircularProgressIndicator()
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

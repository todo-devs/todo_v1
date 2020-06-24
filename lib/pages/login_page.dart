import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:todo/components/login_form.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:nauta_api/nauta_api.dart';

import 'package:todo/pages/connected_page.dart';

import 'package:get_ip/get_ip.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title = 'NAUTA'}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ProgressDialog pr;
  String wlanIp;
  String ip;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    NautaClient().getWlanUserIP().then((value) {
      GetIp.ipAddress.then((value2) {
        setState(() {
          wlanIp = value;
          ip = value2;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, isDismissible: false);

    pr.style(
      borderRadius: 0.0,
      progressWidget: Container(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
      messageTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 19.0,
      ),
    );

    reconnect();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 100,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: Icon(
                Icons.wifi_lock,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
              child: wlanIp != null && ip != null
                  ? Center(child: checkIp())
                  : null,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45.0),
                bottomRight: Radius.circular(45.0),
              ),
            ),
            alignment: Alignment.center,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: LoginForm(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget checkIp() {
    String ok =
        "Usted se encuentra conectado directamente a la red WIFI_ETECSA.";
    String bad =
        "Usted está pasando por un intermediario para llegar a la red WIFI_ETECSA.";
    bool cmp = ip == wlanIp;

    return Text(
      cmp ? ok : bad,
      style: TextStyle(
        color: cmp ? Colors.lightGreenAccent : Colors.pinkAccent,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void reconnect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('nauta_username');

    try {
      if (await NautaProtocol.isConnected()) {
        pr.style(message: 'Reconectando');
        await pr.show();
        await pr.hide();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectedPage(
              title: 'Conectado',
              username: username,
            ),
          ),
        );
      } // end if isConnected
    } on NautaException catch (e) {
      await prefs.remove('nauta_username');
      await pr.hide();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      );
    } // end try_catch
  } // end reconnect()
} // end _LoginPageState

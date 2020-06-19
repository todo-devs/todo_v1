import 'package:flutter/material.dart';

import 'package:todo/pages/login_page.dart';

import 'package:todo/components/ussd_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:nauta_api/nauta_api.dart';

import 'package:todo/pages/connected_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: load,
        child: Icon(Icons.wifi),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: UssdRootWidget(),
      ),
    );
  }

  void load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('nauta_username');

    if(username != null && await NautaProtocol.isConnected()){
      try {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectedPage(
              title: 'Conectado',
              username: username,
            ),
          ),
        );
      } on NautaException catch (e) {
        await prefs.remove('nauta_username');
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              e.message,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        );
      }
    }
    else{
      await prefs.remove('nauta_username');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            title: 'NAUTA',
          ),
        ),
      );
    }
  }
}


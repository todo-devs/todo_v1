import 'package:flutter/material.dart';

import 'package:todo/pages/login_page.dart';

import 'package:todo/components/ussd_widget.dart';

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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                title: 'NAUTA',
              ),
            ),
          );
        },
        child: Icon(Icons.wifi),
      ),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Icon(
                Icons.developer_mode,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 180.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45.0),
                bottomRight: Radius.circular(45.0),
              ),
            ),
            child: UssdRootWidget(),
          )
        ],
      ),
    );
  }
}

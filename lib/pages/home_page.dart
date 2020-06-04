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
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
      ),
      body: ListView(children: <Widget>[
        Container(
          height: 100,
          color: Colors.blue,
          child: Center(
            child: Icon(Icons.developer_mode, size: 64, color: Colors.white),
          ),
        ),
        Container(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(
                            title: 'Wifi Login',
                          )));
            },
            child: Container(
                child: ListTile(
              title: Text('Wifi Login'),
              leading: Icon(
                Icons.wifi,
                color: Colors.blue,
              ),
            )),
          ),
        ),
        Divider(color: Colors.blue),
        Container(
          height: MediaQuery.of(context).size.height - 170,
          child: UssdCategoriesWidget(),
        ),
      ]),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:fetk/pages/login_page.dart';

import 'package:fetk/components/ussd_widget.dart';

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
          title: Text(widget.title),
        ),
        body: Container(
          alignment: Alignment.center,
          child: ListView(children: <Widget>[
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
                child: Card(
                    child: ListTile(
                  title: Text('Wifi Login'),
                  leading: Icon(
                    Icons.wifi,
                    color: Colors.blue,
                  ),
                )),
              ),
            ),
            Divider(),
            Container(
              height: MediaQuery.of(context).size.height,
              child: UssdWidgets(),
            )
          ]),
        ));
  }
}

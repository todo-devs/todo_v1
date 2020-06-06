import 'package:flutter/material.dart';
import 'package:todo/components/connected_form.dart';

class ConnectedPage extends StatefulWidget {
  ConnectedPage({Key key, this.title = 'Conectado', this.username}) : super(key: key);

  final String title;
  final String username;

  @override
  _ConnectedPageState createState() => _ConnectedPageState();
}

class _ConnectedPageState extends State<ConnectedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 80,
              color: Colors.blue,
              child: Center(
                child: Icon(
                  Icons.wifi,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ConnectedForm(
                              username: widget.username,
                            )),
                      ))),
            ),
          ],
        ));
  }
}

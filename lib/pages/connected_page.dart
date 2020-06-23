import 'package:flutter/material.dart';
import 'package:todo/components/connected_form.dart';

class ConnectedPage extends StatefulWidget {
  ConnectedPage({Key key, this.title = 'Conectado', this.username})
      : super(key: key);

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
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
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
            height: 80,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: Icon(
                Icons.wifi,
                size: 64,
                color: Colors.white,
              ),
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
                padding: EdgeInsets.all(10.0),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ConnectedForm(
                    username: widget.username,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

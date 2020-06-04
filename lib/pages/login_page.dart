import 'package:flutter/material.dart';
import 'package:todo/components/login_form.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                child: Icon(Icons.wifi, size: 64, color: Colors.white,),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 100,
              alignment: Alignment.center,
              child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(20.0), child: LoginForm()),
                      ))),
            ),
          ],
        ));
  }
}

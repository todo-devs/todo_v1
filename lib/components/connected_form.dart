import 'package:flutter/material.dart';

import 'package:nauta_api/nauta_api.dart';
import 'package:todo/pages/login_page.dart';

class ConnectedForm extends StatefulWidget {
  final String username;

  ConnectedForm({this.username});

  @override
  _ConnectedFormState createState() => _ConnectedFormState();
}

class _ConnectedFormState extends State<ConnectedForm> {
  NautaClient nautaClient;

  @override
  void initState() {
    super.initState();

    setState(() {
      nautaClient = NautaClient(user: widget.username, password: '');

      nautaClient.loadLastSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Conectado',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Icon(
                Icons.network_wifi,
                size: 64,
                color: Colors.blue,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(widget.username),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: MaterialButton(
              color: Colors.blue,
              minWidth: MediaQuery.of(context).size.width,
              child: Text(
                'Salir',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await nautaClient.logout();

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          )
        ],
      ),
    );
  }
}

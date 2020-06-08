import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
  ProgressDialog pr;

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
            padding: EdgeInsets.all(10.0),
            child: MaterialButton(
              color: Colors.blue,
              minWidth: MediaQuery.of(context).size.width,
              child: Text(
                'Salir',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                pr.style(message: 'Desconectando');
                await pr.show();

                try {
                  await nautaClient.logout();

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } on NautaLogoutException catch (e) {
                  await pr.hide();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      e.message,
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

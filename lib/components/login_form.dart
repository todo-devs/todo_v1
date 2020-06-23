import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:todo/models/user.dart';
import 'package:todo/pages/connected_page.dart';

import 'package:nauta_api/nauta_api.dart';

import 'package:webview_flutter/webview_flutter.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  User _user = User();

  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, isDismissible: false);

    pr.style(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      borderRadius: 0.0,
      progressWidget: Container(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
      messageTextStyle: TextStyle(
        fontSize: 19.0,
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              autovalidate: true,
              decoration: InputDecoration(
                labelText: 'Usuario',
                prefixIcon: Icon(
                  Icons.alternate_email,
                  size: 28,
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Este campo no debe estar vacío';
                }

                return null;
              },
              enableSuggestions: true,
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => setState(() => _user.username = val),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              obscureText: true,
              autovalidate: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  size: 28,
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Este campo no debe estar vacío';
                }

                return null;
              },
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => setState(() => _user.password = val),
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: MaterialButton(
                  elevation: 0.5,
                  color: Colors.blue,
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    'Conectar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: login,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: MaterialButton(
                    elevation: 0.5,
                    color: Colors.lightBlue,
                    child: Text(
                      'Crédito',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: credit,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: MaterialButton(
                    elevation: 0.5,
                    color: Colors.lightBlue,
                    child: Text(
                      'Portal Nauta',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: portalNauta,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void login() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      if (!_user.username.contains('@')) {
        _user.username += '@nauta.com.cu';
      }

      var nautaClient =
          NautaClient(user: _user.username, password: _user.password);

      pr.style(message: 'Conectando');
      await pr.show();

      try {
        await nautaClient.login();

        await pr.hide();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectedPage(
              title: 'Conectado',
              username: _user.username,
            ),
          ),
        );
      } on NautaException catch (e) {
        await pr.hide();
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
    } // end if (form.validate())
  } // end login()

  void credit() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      if (!_user.username.contains('@')) {
        _user.username += '@nauta.com.cu';
      }

      var nautaClient =
          NautaClient(user: _user.username, password: _user.password);

      pr.style(message: 'Solicitando');
      await pr.show();

      try {
        final userCredit = await nautaClient.userCredit();

        await pr.hide();

        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 10),
          backgroundColor: Colors.blueAccent,
          content: Text(
            'Crédito: $userCredit',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
        ));
      } on NautaException catch (e) {
        await pr.hide();
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ));
      }
    } // end if (form.validate())
  } // end credit()

  void portalNauta() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PortalNauta(),
      ),
    );
  }
}

class PortalNauta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Portal Nauta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: WebView(
        initialUrl: "https://www.portal.nauta.cu",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

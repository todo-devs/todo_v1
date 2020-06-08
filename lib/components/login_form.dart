import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:todo/models/user.dart';
import 'package:todo/pages/connected_page.dart';

import 'package:nauta_api/nauta_api.dart';

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

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Login Nauta',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              autovalidate: true,
              decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    size: 32,
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Este campo no debe estar vacío';
                }
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
                  size: 32,
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Este campo no debe estar vacío';
                }
              },
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => setState(() => _user.password = val),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: MaterialButton(
              color: Colors.blue,
              minWidth: MediaQuery.of(context).size.width,
              child: Text(
                'Conectar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                // Hide keyboard
                FocusScope.of(context).unfocus();

                final form = _formKey.currentState;
                if (form.validate()) {
                  form.save();

                  if(!_user.username.contains('@')) {
                    _user.username += '@nauta.com.cu';
                  }

                  var nautaClient = NautaClient(
                      user: _user.username, password: _user.password);

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
                                )));
                  } on NautaPreLoginException catch (e) {
                    await pr.hide();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        e.message,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                    ));
                  } on NautaLoginException catch (e) {
                    await pr.hide();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        e.message,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                    ));
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

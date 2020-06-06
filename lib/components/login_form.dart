import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
              autovalidate: true,
              decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    size: 32,
                  )),
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
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final form = _formKey.currentState;
                if (form.validate()) {
                  form.save();

                  var nautaClient = NautaClient(
                      user: _user.username, password: _user.password);

                  await nautaClient.login();

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConnectedPage(
                                title: 'Conectado',
                                username: _user.username,
                              )));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

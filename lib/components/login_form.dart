import 'package:flutter/material.dart';

import 'package:todo/models/user.dart';

import 'package:nauta_api/nauta_api.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  NautaClient nautaClient;

  User _user = User();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Login Nauta',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    size: 32,
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Username empty';
                }
              },
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => setState(() => _user.username = val),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    size: 32,
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password is empty';
                }
              },
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => setState(() => _user.password = val),
            ),
          ),
          Text(
            'FUNCION EN DESARROLLO',
            style: TextStyle(color: Colors.red),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                MaterialButton(
                  color: Colors.blue,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();

                      nautaClient = NautaClient(
                          user: _user.username, password: _user.password);

                      nautaClient.login();
                    }
                  },
                ),
                MaterialButton(
                  color: Colors.blue,
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if(nautaClient != null)
                      nautaClient.logout();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

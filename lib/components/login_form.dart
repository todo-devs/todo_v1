import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nauta_api/nauta_api.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/components/portal_nauta.dart';
import 'package:todo/models/user.dart';
import 'package:todo/pages/connected_page.dart';
import 'package:todo/utils/transitions.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  User _user = User();

  List<User> _users;

  ProgressDialog pr;

  bool hidePass = true;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    final users = await User.getAll();

    setState(() {
      _users = users;
    });
  }

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
                icon: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.user,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Este campo no debe estar vacío';
                }

                if (value.contains('@')) {
                  final domain = value.split('@')[1];

                  if (domain != 'nauta.com.cu' && domain != 'nauta.co.cu') {
                    return '@nauta.com.cu o @nauta.co.cu';
                  }
                }

                return null;
              },
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => setState(() => _user.username = val),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              enableInteractiveSelection: false,
              obscureText: hidePass,
              autovalidate: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                icon: IconButton(
                  icon: Icon(
                    hidePass ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePass = !hidePass;
                    });
                  },
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
                  color: Theme.of(context).focusColor,
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
                    color: Theme.of(context).focusColor,
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
                    color: Theme.of(context).focusColor,
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

        if (_users == null || !accountSaved()) {
          await showSaveAccountDialog(context);
        }

        Navigator.pushReplacement(
          context,
          TodoPageRoute(
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
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } // end if (form.validate())
  } // end login()

  bool accountSaved() {
    for (var i = 0; i < _users.length; i++)
      if (_users[i].username == _user.username) return true;

    return false;
  }

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
          backgroundColor: Theme.of(context).focusColor,
          content: Text(
            'Crédito: $userCredit',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Colors.white,
            ),
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
      TodoPageRoute(
        builder: (context) => PortalNauta(),
      ),
    );
  }

  showSaveAccountDialog(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Si"),
      onPressed: () async {
        _user.id = _users.length == 0 ? 0 : _users.last.id + 1;
        await _user.save();

        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('lastAccount', _user.username);

        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Guardar cuenta"),
      content: Text("¿Desea guardar su cuenta?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

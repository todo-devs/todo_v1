import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:todo/models/user.dart';
import 'package:nauta_api/nauta_api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/pages/connected_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/utils/transitions.dart';

class AccountPage extends StatefulWidget {
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<User> _users;

  String username;
  String password;

  IconData networkIcon;

  var suscription;

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();

    Connectivity()
        .checkConnectivity()
        .then((value) => updateNetworkState(value));

    suscription =
        Connectivity().onConnectivityChanged.listen(updateNetworkState);

    _loadData();
  }

  void _loadData() async {
    final users = await User.getAll();

    setState(() {
      _users = users;
    });
  }

  void updateNetworkState(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile) {
      setState(() {
        networkIcon = Icons.network_cell;
      });
    } else if (result == ConnectivityResult.wifi) {
      setState(() {
        networkIcon = Icons.wifi_lock;
      });
    } else {
      setState(() {
        networkIcon = Icons.network_locked;
      });
    }
  }

  void dispose() {
    suscription.cancel();
    super.dispose();
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

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).focusColor,
        onPressed: () {
          GlobalKey<FormState> formState = GlobalKey<FormState>();

          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              title: Text('Agregar cuenta'),
              children: <Widget>[
                Form(
                  key: formState,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      TextFormField(
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

                            if (domain != 'nauta.com.cu' &&
                                domain != 'nauta.co.cu') {
                              return '@nauta.com.cu o @nauta.co.cu';
                            }
                          }

                          return null;
                        },
                        onChanged: (value) {
                          username = value;
                        },
                      ),
                      TextFormField(
                        enableInteractiveSelection: false,
                        autovalidate: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          icon: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.eye,
                              size: 28,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Este campo no debe estar vacío';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(height: 15),
                      RaisedButton(
                        color: Theme.of(context).focusColor,
                        onPressed: () async {
                          if (formState.currentState.validate()) {
                            if (!username.contains('@')) {
                              username += '@nauta.com.cu';
                            }

                            await User(
                                    id: _users.length == 0
                                        ? 0
                                        : _users.last.id + 1,
                                    username: username,
                                    password: password)
                                .save();

                            _loadData();

                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(networkIcon),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            centerTitle: true,
            expandedHeight: MediaQuery.of(context).size.height / 4,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Cuentas Nauta',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Icon(
                    Icons.account_circle,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, semanticLabel: "Regresar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            child: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (_users != null) {
                    var item = _users[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(index == 0 ? 20 : 0),
                          topRight: Radius.circular(index == 0 ? 20 : 0),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          GFListTile(
                            margin: EdgeInsets.all(0),
                            avatar: Icon(
                              Icons.account_circle,
                              color: Theme.of(context).focusColor,
                            ),
                            title: Text(item.username.split('@')[0]),
                            description: item.username.contains('.com.cu')
                                ? Text('Internacional')
                                : Text('Nacional'),
                            icon: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.monetization_on,
                                    color: Theme.of(context).focusColor,
                                  ),
                                  onPressed: () {
                                    credit(
                                      context,
                                      item.username,
                                      item.password,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.globeAmericas,
                                    color: Theme.of(context).focusColor,
                                  ),
                                  onPressed: () {
                                    login(
                                      context,
                                      item.username,
                                      item.password,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Theme.of(context).focusColor,
                                  ),
                                  onPressed: () {
                                    item.delete();
                                    _loadData();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Theme.of(context).focusColor,
                          )
                        ],
                      ),
                    );
                  }

                  return SizedBox.shrink();
                },
                childCount: _users != null ? _users.length : 1,
              ),
            ),
          )
        ],
      ),
    );
  }

  void login(BuildContext ctx, String user, String pass) async {
    final nautaClient = NautaClient(user: user, password: pass);

    pr.style(message: 'Conectando');
    await pr.show();

    try {
      await nautaClient.login();

      await pr.hide();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('lastAccount', user);

      Navigator.push(
        ctx,
        TodoPageRoute(
          builder: (context) => ConnectedPage(
            title: 'Conectado',
            username: user,
          ),
        ),
      );
    } on NautaException catch (e) {
      await pr.hide();
      Scaffold.of(ctx).showSnackBar(
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
  } // end login()

  void credit(BuildContext ctx, String user, String pass) async {
    final nautaClient = NautaClient(user: user, password: pass);

    pr.style(message: 'Solicitando');
    await pr.show();

    try {
      final userCredit = await nautaClient.userCredit();

      await pr.hide();

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Theme.of(context).focusColor,
          content: Text(
            'Crédito: $userCredit',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      );
    } on NautaException catch (e) {
      await pr.hide();
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
      );
    }
  } // end credit()
}

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:todo/components/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nauta_api/nauta_api.dart';
import 'package:todo/models/user.dart';
import 'package:todo/pages/connected_page.dart';
import 'package:get_ip/get_ip.dart';
import 'package:connectivity/connectivity.dart';
import 'package:todo/pages/account_page.dart';
import 'package:todo/components/last_account.dart';
import 'package:todo/components/portal_nauta.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title = 'NAUTA'}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ProgressDialog pr;
  String wlanIp;
  String ip;

  IconData networkIcon;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var subscription;

  User lastUser;

  @override
  void initState() {
    super.initState();

    Connectivity()
        .checkConnectivity()
        .then((value) => updateNetworkState(value));

    subscription =
        Connectivity().onConnectivityChanged.listen(updateNetworkState);

    NautaClient().getWlanUserIP().then((value) {
      GetIp.ipAddress.then((value2) {
        setState(() {
          wlanIp = value;
          ip = value2;
        });
      });
    });

    _loadLastAccount();
  }

  void _loadLastAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('lastAccount');

    if (username != null) {
      User user = await User.findByName(username);

      if (user != null) {
        setState(() {
          lastUser = user;
        });
      }
    }
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
    subscription.cancel();
    super.dispose();
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

    reconnect();

    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            expandedHeight: MediaQuery.of(context).size.height / 4,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Icon(
                    networkIcon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AccountPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                    child: wlanIp != null && ip != null ? checkIp() : null,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  alignment: Alignment.center,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: lastUser != null
                            ? LastAccount(
                                user: lastUser,
                              )
                            : LoginForm(),
                      ),
                    ),
                  ),
                ),
                showFormButton()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showFormButton() {
    if (lastUser != null) {
      return Row(
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              setState(() {
                lastUser = null;
              });
            },
            color: Theme.of(context).focusColor,
            child: Text(
              'Mostrar fomulario',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            minWidth: MediaQuery.of(context).size.width / 2,
          ),
          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PortalNauta(),
                ),
              );
            },
            color: Theme.of(context).focusColor,
            child: Text(
              'Portal Nauta',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            minWidth: MediaQuery.of(context).size.width / 2,
          )
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget checkIp() {
    String ok = "Usted se encuentra conectado directamente a la red de ETECSA.";
    String bad =
        "Usted está pasando por un intermediario para conectarse a la red de ETECSA.";
    bool cmp = ip == wlanIp;

    return Container(
      width: MediaQuery.of(context).size.width,
      color: cmp ? Colors.lightGreenAccent : Colors.pinkAccent,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          cmp ? ok : bad,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void reconnect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('nauta_username');

    try {
      if (await NautaProtocol.isConnected()) {
        pr.style(message: 'Reconectando');
        await pr.show();
        await pr.hide();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectedPage(
              title: 'Conectado',
              username: username,
            ),
          ),
        );
      } // end if isConnected
    } on NautaException catch (e) {
      await prefs.remove('nauta_username');
      await pr.hide();
      _scaffoldKey.currentState.showSnackBar(
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
    } // end try_catch
  } // end reconnect()
} // end _LoginPageState

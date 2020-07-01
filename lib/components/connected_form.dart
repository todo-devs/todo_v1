import 'dart:async';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:nauta_api/nauta_api.dart';
import 'package:todo/pages/login_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo/components/portal_nauta.dart';

import 'package:connectivity/connectivity.dart';

class ConnectedForm extends StatefulWidget {
  final String username;

  ConnectedForm({this.username});

  @override
  _ConnectedFormState createState() => _ConnectedFormState();
}

class _ConnectedFormState extends State<ConnectedForm> {
  NautaClient nautaClient;
  ProgressDialog pr;

  get time => remaining.toString().split('.')[0];

  Duration remaining;
  Timer _timer;

  IconData networkIcon;

  var suscription;

  @override
  void initState() {
    super.initState();

    Connectivity()
        .checkConnectivity()
        .then((value) => updateNetworkState(value));

    suscription =
        Connectivity().onConnectivityChanged.listen(updateNetworkState);

    setState(() {
      nautaClient = NautaClient(
        user: widget.username,
        password: '',
      );

      nautaClient.loadLastSession().then((value) => {
            nautaClient.remainingTime().then((value) {
              final rtime = value.split(':');
              final hour = rtime[0];
              final min = rtime[1];
              final sec = rtime[2];
              setState(() {
                remaining = Duration(
                    hours: int.parse(hour),
                    minutes: int.parse(min),
                    seconds: int.parse(sec));
              });
            })
          });
    });

    if (widget.username != null) startTime();
  }

  void updateNetworkState(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile) {
      setState(() {
        networkIcon = Icons.network_cell;
      });
    } else if (result == ConnectivityResult.wifi) {
      setState(() {
        networkIcon = Icons.network_wifi;
      });
    } else {
      setState(() {
        networkIcon = Icons.network_locked;
      });
    }
  }

  void startTime() {
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (remaining.inSeconds < 1) {
            timer.cancel();
          } else {
            final newtime = remaining.inSeconds - 1;
            setState(() {
              remaining = Duration(seconds: newtime);
            });
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
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
        color: Theme.of(context).dialogBackgroundColor,
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
      messageTextStyle: TextStyle(
        fontSize: 19.0,
      ),
    );

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Icon(
                networkIcon,
                size: 64,
                color: Theme.of(context).focusColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              remaining == null ? '' : time,
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 20,
              ),
            ),
          ),
          refreshButton(),
          exitButton(),
          Divider(
            color: Theme.of(context).focusColor,
          ),
          portalButton(),
        ],
      ),
    );
  }

  Widget exitButton() {
    if (widget.username != null)
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: MaterialButton(
          elevation: 0.5,
          color: Theme.of(context).focusColor,
          minWidth: MediaQuery.of(context).size.width,
          child: Text(
            'Cerrar sesión',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            pr.style(message: 'Desconectando');
            await pr.show();

            try {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              // Que primero haga logout
              await nautaClient.logout();

              // Y luego borre la sessión
              await prefs.remove('nauta_username');

              _timer.cancel();
              await pr.hide();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    title: 'NAUTA',
                  ),
                ),
              );
            } on NautaLogoutException catch (e) {
              await pr.hide();
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  e.message,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ));
            }
          },
        ),
      );

    return SizedBox.shrink();
  }

  Widget refreshButton() {
    if (widget.username != null) {
      return Padding(
        padding: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 10.0,
        ),
        child: MaterialButton(
            elevation: 0.5,
            color: Theme.of(context).focusColor,
            minWidth: MediaQuery.of(context).size.width,
            child: Text(
              'Actualizar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              nautaClient.remainingTime().then((value) {
                final rtime = value.split(':');
                final hour = rtime[0];
                final min = rtime[1];
                final sec = rtime[2];
                setState(() {
                  remaining = Duration(
                    hours: int.parse(hour),
                    minutes: int.parse(min),
                    seconds: int.parse(sec),
                  );
                });
              });
            }),
      );
    }
    return SizedBox.shrink();
  }

  Widget portalButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
      ),
      child: MaterialButton(
        elevation: 0.5,
        color: Theme.of(context).focusColor,
        child: Text(
          'Portal Nauta',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: portalNauta,
      ),
    );
  }

  void portalNauta() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PortalNauta(),
      ),
    );
  }
}

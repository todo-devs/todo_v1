import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/components/disclaim.dart';
import 'package:todo/components/settings.dart';
import 'package:todo/pages/login_page.dart';
import 'package:todo/utils/transitions.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  IconData networkIcon;
  var suscription;

  @override
  void initState() {
    super.initState();

    suscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
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
    });
  }

  @override
  void dispose() {
    suscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      final dok = prefs.getBool('dok1.2');

      if (dok == null || !dok)
        Navigator.of(context).push(
          TodoPageRoute(
            builder: (context) => DisclaimerWidget(),
          ),
        );
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, semanticLabel: "Regresar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            title: Text(widget.title),
            actions: <Widget>[
              IconButton(
                icon: Icon(networkIcon, semanticLabel: "Conexión a Nauta"),
                onPressed: () {
                  Navigator.push(
                    context,
                    TodoPageRoute(
                      builder: (context) => LoginPage(
                        title: 'NAUTA',
                      ),
                    ),
                  );
                },
              ),
            ],
            expandedHeight: 10,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
          ),
          SettingsWidget(),
        ],
      ),
    );
  }
}

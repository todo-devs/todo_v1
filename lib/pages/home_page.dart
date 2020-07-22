import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/components/disclaim.dart';
import 'package:todo/components/ussd_widget.dart';
import 'package:todo/pages/account_page.dart';
import 'package:todo/pages/login_page.dart';
import 'package:todo/pages/settings_page.dart';
import 'package:todo/services/AppStateNotifier.dart';
import 'package:todo/services/PlatformService.dart';
import 'package:todo/services/phone.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconData networkIcon;
  var suscription;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then(
      (prefs) {
        final dm = prefs.getBool('darkmode');
        if (dm != null)
          Provider.of<AppStateNotifier>(context, listen: false).updateTheme(dm);
      },
    );

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

    final QuickActions quickActions = QuickActions();

    quickActions.initialize((String shortcutType) {
      switch (shortcutType) {
        case 'saldo':
          callTo('*222#');
          exit(0);
          break;
        case 'datos':
          callTo('*222*328#');
          exit(0);
          break;
        case 'bono':
          callTo('*222*266#');
          exit(0);
          break;
        case 'corp':
          callTo('*111#');
          exit(0);
          break;
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'corp',
        localizedTitle: 'Corporativo',
        icon: 'saldo',
      ),
      const ShortcutItem(
        type: 'bono',
        localizedTitle: 'Bono',
        icon: 'bono',
      ),
      const ShortcutItem(
        type: 'datos',
        localizedTitle: 'Datos',
        icon: 'datos',
      ),
      const ShortcutItem(
        type: 'saldo',
        localizedTitle: 'Saldo',
        icon: 'saldo',
      ),
    ]);
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
          MaterialPageRoute(
            builder: (context) => DisclaimerWidget(),
          ),
        );
    });

    getShowWidgetPreference().then(
      (value) => {
        if (value) {showReqDrawDialog(context)}
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).focusColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                title: 'NAUTA',
              ),
            ),
          );
        },
        child: Icon(
          Icons.wifi,
          color: Colors.white,
          semanticLabel: "Conexión a Nauta",
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(networkIcon, semanticLabel: "Conexión a Nauta"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        title: 'NAUTA',
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle,
                    semanticLabel: "Gestión de cuentas"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AccountPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings,
                    semanticLabel: "Opciones de configuración"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        title: 'Ajustes',
                      ),
                    ),
                  );
                },
              ),
            ],
            expandedHeight: MediaQuery.of(context).size.height / 3,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: Center(
                child: ImageIcon(
                  AssetImage("logo.png"),
                  color: Colors.white,
                  size: 96,
                ),
              ),
            ),
          ),
          UssdRootWidget(),
        ],
      ),
    );
  }

  showReqDrawDialog(BuildContext context) async {
    if (await getDrawPermissionState()) {
      return;
    }

    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () async {
        await reqDrawPermission();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Solicitud de permiso"),
      content: Text(
          "Hola, perdona la molestia pero necesito permiso para poder mostrarte información sobre tu velocidad de conexión,"
          " por favor toca en el botón de continuar y habilita la superposición de pantalla"),
      actions: [
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/services/AppStateNotifier.dart';
import 'package:todo/themes/colors.dart';

class SettingsWidget extends StatefulWidget {
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  var darkMode = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then(
      (prefs) {
        final dm = prefs.getBool('darkmode');
        if (dm != null) {
          setState(() {
            darkMode = dm;
          });

          Provider.of<AppStateNotifier>(context, listen: false).updateTheme(dm);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Activar modo oscuro',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  activeColor: GFColors.SUCCESS,
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });

                    Provider.of<AppStateNotifier>(context, listen: false)
                        .updateTheme(darkMode);

                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setBool('darkmode', darkMode);
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

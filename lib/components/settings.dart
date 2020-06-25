import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/pages/download_ussd_page.dart';
import 'package:todo/services/AppStateNotifier.dart';
import 'package:todo/components/disclaim.dart';
import 'package:getflutter/getflutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            Text(
              'Versión 1.2.0 | 25-06-2020',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Activar modo oscuro',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  activeColor: Theme.of(context).focusColor,
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
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Actualizar códigos USSD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      Icons.file_download,
                      color: Theme.of(context).scaffoldBackgroundColor ==
                              Theme.of(context).focusColor
                          ? Colors.white
                          : Theme.of(context).focusColor,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DownloadUssdPage(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisclaimerWidget(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Términos de uso',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      Icons.verified_user,
                      color: Theme.of(context).scaffoldBackgroundColor ==
                              Theme.of(context).focusColor
                          ? Colors.white
                          : Theme.of(context).focusColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: GFButton(
                icon: Icon(
                  FontAwesomeIcons.telegram,
                  color: Theme.of(context).scaffoldBackgroundColor ==
                          Theme.of(context).focusColor
                      ? Colors.white
                      : Theme.of(context).focusColor,
                ),
                text: 'Habla con nosotros en Telegram',
                textColor: Colors.white,
                color: Theme.of(context).scaffoldBackgroundColor ==
                        Theme.of(context).focusColor
                    ? Colors.white
                    : Theme.of(context).focusColor,
                size: GFSize.LARGE,
                type: GFButtonType.outline2x,
                fullWidthButton: true,
                onPressed: () async {
                  const url = 'https://t.me/todoapp_cuba';
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

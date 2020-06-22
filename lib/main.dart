import 'package:flutter/material.dart';

import 'package:todo/pages/home_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var darkMode = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      final dm = prefs.getBool('darkmode');

      if (dm != null)
        setState(() {
          darkMode = dm;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = darkMode ? Colors.greenAccent : Colors.blue;

    print(darkMode);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0.0,
        ),
        scaffoldBackgroundColor: color,
      ),
      home: HomePage(title: 'TODO'),
    );
  }
}

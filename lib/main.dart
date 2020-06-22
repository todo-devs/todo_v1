import 'package:flutter/material.dart';

import 'package:todo/pages/home_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0.0,
        ),
        scaffoldBackgroundColor: Colors.blue,
      ),
      home: HomePage(title: 'TODO'),
    );
  }
}
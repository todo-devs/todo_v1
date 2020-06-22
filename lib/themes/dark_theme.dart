import 'package:flutter/material.dart';
import 'package:todo/themes/colors.dart';

final themeDark = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Montserrat',
  appBarTheme: AppBarTheme(
    color: Colors.transparent,
    elevation: 0.0,
  ),
  scaffoldBackgroundColor: Color.fromRGBO(39, 50, 80, 1),
  dialogBackgroundColor: Color.fromRGBO(55, 65, 104, 1),
  focusColor: GFColors.SUCCESS
);

import 'package:flutter/material.dart';
import 'package:fetk/services/ussd.dart';

import 'package:fetk/config/ussd_codes.dart';

class UssdWidget extends StatelessWidget {
  final String name;
  final String code;
  final IconData icon;

  UssdWidget({this.name, this.code, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUssd(code);
      },
      child: Card(
          child: ListTile(
        title: Text(name),
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
      )),
    );
  }
}

class UssdWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: ussdCodes.length,
        itemBuilder: (context, index) {
          return UssdWidget(
            name: ussdCodes[index].name,
            code: ussdCodes[index].code,
            icon: ussdCodes[index].icon,
          );
        });
  }
}

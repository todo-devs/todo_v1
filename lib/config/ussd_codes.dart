import 'package:flutter/material.dart';

var ussdCodes = [
  UssdOption(name: 'Consultar Saldo', code: '*222#', icon: Icons.attach_money),
  UssdOption(name: 'Consultar Saldo 2', code: '*222#', icon: Icons.account_box),
  UssdOption(name: 'Consultar Saldo 3', code: '*222#', icon: Icons.email),
  UssdOption(name: 'Ussd option 1', code: '*222#', icon: Icons.code),
  UssdOption(name: 'Ussd option 2', code: '*222#', icon: Icons.developer_mode)
];

class UssdOption {
  final String name;
  final String code;
  final IconData icon;

  UssdOption({this.name, this.code, this.icon});
}

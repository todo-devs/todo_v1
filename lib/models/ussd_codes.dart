import 'package:flutter/material.dart';
import 'package:todo/utils/icons.dart';

class UssdCodes {
  List<UssdCode> codes;

  UssdCodes({this.codes});

  factory UssdCodes.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['codes'] as List;

    List<UssdCode> codesList = list.map((i) => UssdCode.fromJson(i)).toList();

    return UssdCodes(codes: codesList);
  }
}

class UssdCode {
  String name;
  String code;
  IconData icon;

  List<UssdCodeField> fields;

  UssdCode({this.name, this.code, this.fields, this.icon});

  factory UssdCode.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['fields'] as List;
    List<UssdCodeField> fieldsList =
        list.map((i) => UssdCodeField.fromJson(i)).toList();

    var icon;

    try {
      icon = strIcons[parsedJson['icon']];
    } catch (e) {
      icon = Icons.code;
    }

    return UssdCode(
        name: parsedJson['name'],
        code: parsedJson['code'],
        fields: fieldsList,
        icon: icon);
  }
}

class UssdCodeField {
  String name;
  String type;

  UssdCodeField({this.name, this.type});

  factory UssdCodeField.fromJson(Map<String, dynamic> parsedJson) {
    return UssdCodeField(name: parsedJson['name'], type: parsedJson['type']);
  }
}

import 'package:flutter/material.dart';
import 'package:todo/utils/icons.dart';

class UssdCategories {
  List<UssdCategory> categories;

  UssdCategories({this.categories});

  factory UssdCategories.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['categories'] as List;
    List<UssdCategory> categoryList =
        list.map((i) => UssdCategory.parseJson(i)).toList();

    return UssdCategories(categories: categoryList);
  }
}

class UssdCategory {
  List<UssdCode> codes;
  String name;
  IconData icon;

  UssdCategory({this.name, this.icon, this.codes});

  factory UssdCategory.parseJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['codes'] as List;

    List<UssdCode> codesList = list.map((i) => UssdCode.fromJson(i)).toList();

    var icon;

    try {
      icon = strIcons[parsedJson['icon']];
    } catch (e) {
      icon = Icons.code;
    }

    return UssdCategory(name: parsedJson['name'], icon: icon, codes: codesList);
  }
}

/*
class UssdCodes {
  List<UssdCode> codes;

  UssdCodes({this.codes});

  factory UssdCodes.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['codes'] as List;

    List<UssdCode> codesList = list.map((i) => UssdCode.fromJson(i)).toList();

    return UssdCodes(codes: codesList);
  }
}
*/

class UssdCode {
  String name;
  String code;
  IconData icon;
  String type;

  List<UssdCodeField> fields;

  UssdCode({this.name, this.code, this.fields, this.icon, this.type});

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

    var type;

    try {
      type = parsedJson['type'];
    } catch (e) {
      type = null;
    }

    return UssdCode(
        name: parsedJson['name'],
        code: parsedJson['code'],
        fields: fieldsList,
        icon: icon,
        type: type);
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

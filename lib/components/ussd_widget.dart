import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo/services/contacts.dart';
import 'package:todo/services/phone.dart';
import 'package:todo/models/ussd_codes.dart';
import 'package:getflutter/getflutter.dart';

class UssdRootWidget extends StatefulWidget {
  _UssdRootState createState() => _UssdRootState();
}

class _UssdRootState extends State<UssdRootWidget> {
  List<UssdItem> items;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    String data;
    Map<String, dynamic> parsedJson;
    try {
      var prefs = await SharedPreferences.getInstance();
      var lastHash = prefs.getString('hash');
      var lastDay = prefs.getInt('day');
      var actualDay = DateTime.now().day;

      data ??= prefs.getString('config');
      data ??= await rootBundle.loadString('config/ussd_codes.json');
      parsedJson = jsonDecode(data);

      setState(() {
        items = UssdRoot.fromJson(parsedJson).items;
      });

      if (lastDay == null || lastDay != actualDay) {
        try {
          var resp = await get(
            'https://todo-devs.github.io/todo-json/hash.json',
            headers: {
              'Accept-Encoding': 'gzip, deflate, br',
            },
          );
          if (resp.statusCode == 200) {
            var json = jsonDecode(utf8.decode(resp.bodyBytes));
            var actualHash = json['hash'];
            if (actualHash != lastHash) {
              var resp = await get(
                'https://todo-devs.github.io/todo-json/config.json',
                headers: {
                  'Accept-Encoding': 'gzip, deflate, br',
                },
              );
              if (resp.statusCode == 200) {
                var body = utf8.decode(resp.bodyBytes);
                data = body;
                prefs.setString('hash', actualHash);
                prefs.setString('config', body);
              }
            }
            prefs.setInt('day', actualDay);
          }
        } catch (e) {
          log(e.toString());
        }
      }
      data ??= prefs.getString('config');
      data ??= await rootBundle.loadString('config/ussd_codes.json');
      parsedJson = jsonDecode(data);
    } catch (e) {
      log(e.toString());
      data = await rootBundle.loadString('config/ussd_codes.json');
      parsedJson = jsonDecode(data);
    }
    setState(() {
      items = UssdRoot.fromJson(parsedJson).items;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items != null)
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];

          if (item.type == 'code')
            return Padding(
              padding: EdgeInsets.only(
                left: 14.0,
                right: 14.0,
                top: index == 0 ? 10 : 0,
              ),
              child: UssdWidget(
                ussdCode: item,
              ),
            );
          else
            return Padding(
              padding: EdgeInsets.only(
                left: 14.0,
                right: 14.0,
                top: index == 0 ? 10 : 0,
              ),
              child: UssdCategoryWidget(
                category: item,
              ),
            );
        },
      );

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class UssdCategoryWidget extends StatelessWidget {
  final UssdCategory category;

  UssdCategoryWidget({this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UssdWidgets(
              title: category.name.toUpperCase(),
              ussdItems: category.items,
              icon: category.icon,
            ),
          ),
        );
      },
      child: Column(children: <Widget>[
        GFListTile(
          margin: EdgeInsets.all(0),
          avatar: Icon(category.icon, color: Theme.of(context).focusColor),
          description: Text(
            category.description,
            style: TextStyle(
              color: Theme.of(context).focusColor,
            ),
          ),
          title: Text(
            category.name.toUpperCase(),
          ),
        ),
        Divider(
          color: Theme.of(context).focusColor,
        )
      ]),
    );
  }
}

class UssdWidgets extends StatelessWidget {
  final List<UssdItem> ussdItems;
  final String title;
  final IconData icon;

  UssdWidgets({this.ussdItems, this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 100,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Icon(icon, size: 64, color: Colors.white),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45.0),
                bottomRight: Radius.circular(45.0),
              ),
            ),
            height: MediaQuery.of(context).size.height - 180,
            child: ListView.builder(
              itemCount: ussdItems.length,
              itemBuilder: (context, index) {
                var item = ussdItems[index];

                if (item.type == 'code')
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 14.0,
                      right: 14.0,
                      top: index == 0 ? 10 : 0,
                    ),
                    child: UssdWidget(
                      ussdCode: item,
                    ),
                  );
                else
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 14.0,
                      right: 14.0,
                      top: index == 0 ? 10 : 0,
                    ),
                    child: UssdCategoryWidget(
                      category: item,
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UssdWidget extends StatelessWidget {
  final UssdCode ussdCode;

  UssdWidget({this.ussdCode});

  @override
  Widget build(BuildContext context) {
    if (ussdCode.fields.isEmpty) {
      return SimpleCode(
        code: ussdCode.code,
        name: ussdCode.name,
        icon: ussdCode.icon,
        description: ussdCode.description,
      );
    }

    return CodeWithForm(code: ussdCode);
  }
}

class SimpleCode extends StatelessWidget {
  final String code;
  final String name;
  final String description;
  final IconData icon;

  SimpleCode({this.code, this.name, this.icon, this.description});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callTo(code);
      },
      child: Column(children: <Widget>[
        GFListTile(
          margin: EdgeInsets.all(0),
          avatar: Icon(icon, color: Theme.of(context).focusColor),
          description: Text(
            description,
            style: TextStyle(
              color: Theme.of(context).focusColor,
            ),
          ),
          title: Text(
            name.toUpperCase(),
          ),
        ),
        Divider(
          color: Theme.of(context).focusColor,
        )
      ]),
    );
  }
}

class CodeWithForm extends StatelessWidget {
  final UssdCode code;

  CodeWithForm({this.code});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CodeFormPage(
              code: code,
            ),
          ),
        );
      },
      child: Column(children: <Widget>[
        GFListTile(
          margin: EdgeInsets.all(0),
          avatar: Icon(code.icon, color: Theme.of(context).focusColor),
          description: Text(
            code.description,
            style: TextStyle(
              color: Theme.of(context).focusColor,
            ),
          ),
          title: Text(code.name.toUpperCase()),
        ),
        Divider(
          color: Theme.of(context).focusColor,
        )
      ]),
    );
  }
}

class CodeFormPage extends StatelessWidget {
  final UssdCode code;

  CodeFormPage({this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          code.name.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 80,
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45.0),
                bottomRight: Radius.circular(45.0),
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CodeForm(
                    code: code.code,
                    fields: code.fields,
                    type: code.type,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CodeForm extends StatefulWidget {
  final List<UssdCodeField> fields;
  final String code;
  final String type;

  CodeForm({this.code, this.fields, this.type});

  _CodeFormState createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();

  String code;

  @override
  void initState() {
    super.initState();

    setState(() {
      code = widget.code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView.builder(
        itemCount: widget.fields.length + 1,
        itemBuilder: (_, index) {
          if (index == widget.fields.length) {
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: MaterialButton(
                elevation: 0.5,
                color: Theme.of(context).focusColor,
                minWidth: MediaQuery.of(context).size.width,
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  final form = _formKey.currentState;

                  if (widget.type == "debug") {
                    if (form.validate()) {
                      form.save();

                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Run USSD Code\n$code'),
                      ));
                    }
                  } else {
                    if (form.validate()) {
                      form.save();
                      callTo(code);
                    }
                  }
                },
              ),
            );
          }

          final UssdCodeField field = widget.fields[index];

          switch (field.type) {
            // INPUT PHONE_NUMBER
            case 'phone_number':
              return TextFormField(
                controller: phoneNumberController,
                maxLength: 8,
                autovalidate: true,
                decoration: InputDecoration(
                    labelText: field.name.toUpperCase(),
                    suffixIcon: FlatButton(
                        onPressed: () async {
                          String number = await getContactPhoneNumber();

                          phoneNumberController.text = number;
                          phoneNumberController.addListener(() {
                            phoneNumberController.selection =
                                TextSelection(baseOffset: 8, extentOffset: 8);
                          });
                        },
                        child: Icon(
                          Icons.contacts,
                          color: Theme.of(context).focusColor,
                        )),
                    prefixIcon: Icon(
                      Icons.phone,
                    )),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo no debe estar vacío';
                  }

                  if (value.length < 8) {
                    return 'Este campo debe contener 8 digitos';
                  }

                  if (value[0] != '5') {
                    return 'Este campo debe comenzar con el dígito 5';
                  }

                  return null;
                },
                keyboardType: TextInputType.phone,
                onSaved: (val) {
                  String rem = '{${field.name}}';

                  String newCode = code.replaceAll(rem, val);

                  setState(() {
                    code = newCode;
                  });
                },
              );

            // INPUT MONEY
            case 'money':
              return TextFormField(
                  autovalidate: true,
                  decoration: InputDecoration(
                      labelText: field.name.toUpperCase(),
                      prefixIcon: Icon(
                        Icons.attach_money,
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Este campo no debe estar vacío';
                    }

                    try {
                      final cant = double.parse(value);

                      if (cant.isNegative) {
                        return 'Debe poner una cantidad mayor que cero';
                      }
                      if(value.split('.')[1].length > 2) {
                        return 'Solo se admiten valores de tipo monetario';
                      }
                    } on RangeError {
                      return null;
                    }
                    catch(e) {
                      return 'Solo se admiten valores de tipo monetario';
                    }

                    return null;
                  },
                  keyboardType: TextInputType.number,
                  onSaved: (val) {
                    String rem = '{${field.name}}';

                    String newCode = code.replaceAll(rem, val);

                    setState(() {
                      code = newCode;
                    });
                  });

            // INPUT KEY
            case 'key_number':
              return TextFormField(
                obscureText: true,
                maxLength: 4,
                autovalidate: true,
                decoration: InputDecoration(
                    labelText: field.name.toUpperCase(),
                    prefixIcon: Icon(
                      Icons.vpn_key,
                    )),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo no debe estar vacío';
                  }

                  if (value.length != 4) {
                    return 'La clave debe contener 4 dígitos';
                  }

                  try {
                    if(int.parse(value) < 0) {
                      return 'La clave no debe contener símbolos';
                    }
                  }
                  catch(e) {
                    return 'La clave no debe contener símbolos';
                  }

                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (val) {
                  String rem = '{${field.name}}';

                  String newCode = code.replaceAll(rem, val);

                  setState(() {
                    code = newCode;
                  });
                },
              );

            // INPUT CARD NUMBER
            case 'card_number':
              return TextFormField(
                maxLength: 16,
                autovalidate: true,
                decoration: InputDecoration(
                    labelText: field.name.toUpperCase(),
                    prefixIcon: Icon(
                      Icons.credit_card,
                    )),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo no debe estar vacío';
                  }

                  if (value.length != 16) {
                    return 'El número de la tarjeta debe contener 16 dígitos';
                  }

                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (val) {
                  String rem = '{${field.name}}';

                  String newCode = code.replaceAll(rem, val);

                  setState(() {
                    code = newCode;
                  });
                },
              );

            // DEFAULT ONLY FOR DEBUG
            default:
              return Text('Type of field ${field.type} unknown');
          }
        },
      ),
    );
  }
}

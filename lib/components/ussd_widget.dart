import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:todo/services/contacts.dart';
import 'package:todo/services/phone.dart';
import 'package:todo/models/ussd_codes.dart';

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
    final data = await rootBundle.loadString('config/ussd_codes.json');

    final parsedJson = jsonDecode(data);

    setState(() {
      items = UssdRoot.fromJson(parsedJson).items;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items != null)
      return ListView.builder(
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index == 0)
              return Container(
                height: 100,
                color: Colors.blue,
                child: Center(
                  child:
                      Icon(Icons.developer_mode, size: 64, color: Colors.white),
                ),
              );

            var item = items[index - 1];

            if (item.type == 'code')
              return UssdWidget(
                ussdCode: item,
              );
            else
              return UssdCategoryWidget(
                category: item,
              );
          });

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
                icon: category.icon),
          ),
        );
      },
      child: Column(children: <Widget>[
        ListTile(
          leading: Icon(category.icon, color: Colors.blue),
          title: Text(category.name.toUpperCase()),
        ),
        Divider(
          color: Colors.blue,
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
        elevation: 0,
        title: Text(title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: ussdItems.length + 1,
            itemBuilder: (context, index) {
              if (index == 0)
                return Container(
                  height: 100,
                  color: Colors.blue,
                  child: Icon(icon, size: 64, color: Colors.white),
                );

              var item = ussdItems[index - 1];

              if (item.type == 'code')
                return UssdWidget(
                  ussdCode: item,
                );
              else
                return UssdCategoryWidget(
                  category: item,
                );
            }),
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
      );
    }

    return CodeWithForm(code: ussdCode);
  }
}

class SimpleCode extends StatelessWidget {
  final String code;
  final String name;
  final IconData icon;

  SimpleCode({this.code, this.name, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callTo(code);
      },
      child: Column(children: <Widget>[
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(name.toUpperCase()),
        ),
        Divider(
          color: Colors.blue,
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
        ListTile(
          leading: Icon(code.icon, color: Colors.blue),
          title: Text(code.name.toUpperCase()),
        ),
        Divider(
          color: Colors.blue,
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
        elevation: 0,
        title: Text(code.name.toUpperCase()),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Center(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CodeForm(
                        code: code.code,
                        fields: code.fields,
                        type: code.type,
                      )),
                ))),
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
        itemBuilder: (contex, index) {
          if (index == widget.fields.length) {
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: MaterialButton(
                color: Colors.blue,
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
                          color: Colors.blue,
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
                      if (int.parse(value) <= 0) {
                        return 'Debe poner una cantidad mayor que cero';
                      }
                    } catch (e) {
                      return 'Este campo solo puede conetener digitos';
                    }
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

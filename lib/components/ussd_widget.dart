import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:todo/services/ussd.dart';
import 'package:todo/models/ussd_codes.dart';

class UssdCategoriesWidget extends StatefulWidget {
  _UssdCategoriesState createState() => _UssdCategoriesState();
}

class _UssdCategoriesState extends State<UssdCategoriesWidget> {
  List<UssdCategory> categories;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    final data = await rootBundle.loadString('config/ussd_codes.json');

    final parsedJson = jsonDecode(data);

    setState(() {
      categories = UssdCategories.fromJson(parsedJson).categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categories != null)
      return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return UssdCategoryWidget(
              category: categories[index],
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
                title: category.name,
                ussdCodes: category.codes,
                icon: category.icon),
          ),
        );
      },
      child: Column(children: <Widget>[
        ListTile(
          leading: Icon(category.icon, color: Colors.blue),
          title: Text(category.name),
        ),
        Divider(
          color: Colors.blue,
        )
      ]),
    );
  }
}

class UssdWidgets extends StatelessWidget {
  final List<UssdCode> ussdCodes;
  final String title;
  final IconData icon;

  UssdWidgets({this.ussdCodes, this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 100,
            color: Colors.blue,
            child: Icon(icon, size: 64, color: Colors.white),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: ListView.builder(
                itemCount: ussdCodes.length,
                itemBuilder: (context, index) {
                  return UssdWidget(
                    ussdCode: ussdCodes[index],
                  );
                }),
          )
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
        launchUssd(code);
      },
      child: Column(children: <Widget>[
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(name),
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
          title: Text(code.name),
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
        title: Text(code.name),
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
                      )),
                ))),
      ),
    );
  }
}

class CodeForm extends StatefulWidget {
  final List<UssdCodeField> fields;
  final String code;

  CodeForm({this.code, this.fields});

  _CodeFormState createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  final _formKey = GlobalKey<FormState>();

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
                  if (form.validate()) {
                    form.save();

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Run USSD Code\n$code'),
                    ));
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
                maxLength: 8,
                autovalidate: true,
                decoration: InputDecoration(
                    labelText: field.name.toUpperCase(),
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

            // DEFAULT ONLY FOR DEBUG
            default:
              return Text('Type of field ${field.type} unknown');
          }
        },
      ),
    );
  }
}

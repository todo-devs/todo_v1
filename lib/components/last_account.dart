import 'package:flutter/material.dart';
import 'package:todo/models/user.dart';
import 'package:getflutter/getflutter.dart';
import 'package:nauta_api/nauta_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:todo/pages/connected_page.dart';

class LastAccount extends StatefulWidget {
  final User user;

  LastAccount({this.user});

  _LastAccountState createState() => _LastAccountState();
}

class _LastAccountState extends State<LastAccount> {
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, isDismissible: false);

    pr.style(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      borderRadius: 0.0,
      progressWidget: Container(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
      messageTextStyle: TextStyle(
        fontSize: 19.0,
      ),
    );

    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              login(
                context,
                widget.user.username,
                widget.user.password,
              );
            },
            child: GFListTile(
              margin: EdgeInsets.all(0),
              avatar: Icon(
                Icons.account_circle,
                color: Theme.of(context).focusColor,
              ),
              title: Text(widget.user.username.split('@')[0]),
              description: widget.user.username.contains('.com.cu')
                  ? Text('Internacional')
                  : Text('Nacional'),
              icon: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.monetization_on,
                      color: Theme.of(context).focusColor,
                    ),
                    onPressed: () {
                      credit(
                        context,
                        widget.user.username,
                        widget.user.password,
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.globeAmericas,
                      color: Theme.of(context).focusColor,
                    ),
                    onPressed: () {
                      login(
                        context,
                        widget.user.username,
                        widget.user.password,
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void credit(BuildContext ctx, String user, String pass) async {
    final nautaClient = NautaClient(user: user, password: pass);

    pr.style(message: 'Solicitando');
    await pr.show();

    try {
      final userCredit = await nautaClient.userCredit();

      await pr.hide();

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Theme.of(context).focusColor,
          content: Text(
            'Crédito: $userCredit',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      );
    } on NautaException catch (e) {
      await pr.hide();
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
      );
    }
  }

  void login(BuildContext ctx, String user, String pass) async {
    final nautaClient = NautaClient(user: user, password: pass);

    pr.style(message: 'Conectando');
    await pr.show();

    try {
      await nautaClient.login();

      await pr.hide();

      Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (context) => ConnectedPage(
            title: 'Conectado',
            username: user,
          ),
        ),
      );
    } on NautaException catch (e) {
      await pr.hide();
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}

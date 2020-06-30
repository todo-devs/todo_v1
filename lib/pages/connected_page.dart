import 'package:flutter/material.dart';
import 'package:todo/components/connected_form.dart';
import 'package:connectivity/connectivity.dart';

class ConnectedPage extends StatefulWidget {
  ConnectedPage({Key key, this.title = 'Conectado', this.username})
      : super(key: key);

  final String title;
  final String username;

  @override
  _ConnectedPageState createState() => _ConnectedPageState();
}

class _ConnectedPageState extends State<ConnectedPage> {
  String wifiSSID = '';
  String wifiIP = '';

  var suscription;

  @override
  void initState() {
    super.initState();

    Connectivity()
        .checkConnectivity()
        .then((value) => updateNetworkState(value));

    suscription =
        Connectivity().onConnectivityChanged.listen(updateNetworkState);
  }

  updateNetworkState(ConnectivityResult result) async {
    final wifiName = await (Connectivity().getWifiName());
    final ip = await (Connectivity().getWifiIP());

    setState(() {
      wifiSSID = wifiName;
      wifiIP = ip;
    });
  }

  @override
  void dispose() {
    suscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 4,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Text(
                    'SSID:  ' + wifiSSID + '   IP:  ' + wifiIP,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: ConnectedForm(
                          username: widget.username,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

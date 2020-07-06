import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PortalNauta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, semanticLabel: "Regresar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Portal Nauta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: WebView(
        initialUrl: "https://www.portal.nauta.cu",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

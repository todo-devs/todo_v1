import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/themes/colors.dart';
import 'package:todo/pages/home_page.dart';
import 'package:todo/utils/transitions.dart';
import 'package:url_launcher/url_launcher.dart';

class DisclaimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: ImageIcon(
                AssetImage("logo.png"),
                color: Colors.white,
                size: 96,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: disclaimer(),
            ),
          ),
          Center(
            child: MaterialButton(
              onPressed: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool('dok1.2', true);
                  Navigator.of(context).pushAndRemoveUntil(
                      TodoPageRoute(
                        builder: (context) => HomePage(
                          title: 'TODO',
                        ),
                      ),
                      (route) => false);
                });
              },
              color: GFColors.SUCCESS,
              minWidth: MediaQuery.of(context).size.width / 2,
              elevation: 0.5,
              child: Text(
                'YA ENTENDI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget disclaimer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            "Tu Operador de Datos Omnipotente\n",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "TODO es una aplicación de código abierto creada por un grupo de desarrolladores cubanos:",
          style: TextStyle(color: Colors.white),
        ),
        FlatButton(
          child: Text(
            "https://github.com/todo-devs/",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            if (await canLaunch("https://github.com/todo-devs/")) {
              await launch("https://github.com/todo-devs/");
            }
          },
        ),
        Text(
          """con el objetivo de facilitar el acceso a los servicios de ETECSA.

Se recomienda al usuario descargar siempre la aplicación desde las fuentes oficiales, las cuales se listan al final de este escrito y que esté al tanto de las actualizaciones para que la aplicación funcione correctamente. 

No se almacena ni se exporta ningún tipo de información personal del usuario ni del uso que hace de la aplicación.
La información almacenada con respecto a las cuentas de navegación se guarda de manera segura en el dispositivo del usuario y con previa autorización del mismo.

Los servicios solicitados mediante la aplicación responden a las prestaciones de ETECSA, la aplicación solo actúa como una herramienta para facilitar la ejecución de los códigos ussd y la gestión de conexión en el servicio de WIFI_ETECSA y Nauta Hogar. No nos hacemos responsables por demoras o mal funcionamiento de los servicios de la compañía.

No nos hacemos responsables de los daños que pueda ocasionar el uso incorrecto de la aplicación o daños ocasionados por descargar la aplicación desde fuentes no oficiales.

El código de la aplicación se encuentra disponible bajo la licencia GPL3, cualquier tipo de copia, modificación y compilación del código deben hacerse respetando la licencia y bajo principios éticos, no se aceptarán contribuciones al código que traten de engañar a los usuarios o de exportar información de los mismos a servidores externos.

UNA VEZ MÁS HACEMOS ÉNFASIS EN QUE LOS USUARIOS DEBEN DESCARGAR LA APLICACIÓN DESDE FUENTES OFICIALES:

FUENTES OFICIALES:

1. Releases generados automáticamente a partir del código oficial en Github:""",
          style: TextStyle(color: Colors.white),
        ),
        FlatButton(
          child: Text(
            "https://github.com/todo-devs/todo/releases",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          onPressed: () async {
            if (await canLaunch("https://github.com/todo-devs/todo/releases")) {
              await launch("https://github.com/todo-devs/todo/releases");
            }
          },
        ),
        Text(
          """
2. Tienda cubana de aplicaciones Apklis""",
          style: TextStyle(color: Colors.white),
        ),
        FlatButton(
          child: Text(
            "https://www.apklis.cu/application/com.cubanopensource.todo",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          onPressed: () async {
            if (await canLaunch(
                "https://www.apklis.cu/application/com.cubanopensource.todo")) {
              await launch(
                  "https://www.apklis.cu/application/com.cubanopensource.todo");
            }
          },
        ),
        Text(
          """
3. Google Play Store""",
          style: TextStyle(color: Colors.white),
        ),
        FlatButton(
          child: Text(
            "https://play.google.com/store/apps/details?id=com.cubanopensource.todo",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          onPressed: () async {
            if (await canLaunch(
                "https://play.google.com/store/apps/details?id=com.cubanopensource.todo")) {
              await launch(
                  "https://play.google.com/store/apps/details?id=com.cubanopensource.todo");
            }
          },
        ),
        Text(
          """

Fecha de actualización de este acuerdo: 
7 de julio del 2020
""",
          style: TextStyle(
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

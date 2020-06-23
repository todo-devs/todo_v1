import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/themes/colors.dart';
import 'package:todo/pages/home_page.dart';

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
              child: Icon(
                Icons.developer_mode,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Center(
                child: Text(
                  disclaimer,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          Center(
            child: MaterialButton(
              onPressed: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool('dok1', true);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
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

  final String disclaimer = """
TODO es una aplicación de código abierto creada por un grupo de desarrolladores cubanos:

https://github.com/todo-devs/

con el objetivo de facilitar el acceso a los servicios de ETECSA.

Se recomienda al usuario descargar siempre la aplicación desde las fuentes oficiales, las cuáles se listan al final de este escrito y que esté al tanto de las actualizaciones para que la aplicación funcione correctamente. 

No se almacena ni se exporta ningún tipo de información personal del usuario ni del uso que hace de la aplicación.

Los servicios solicitados mediante la aplicación responden a las prestaciones de ETECSA, la aplicación solo actúa como una herramienta para facilitar la ejecución de los códigos ussd y la gestión de conexión en el servicio de WIFI_ETECSA y Nauta Hogar. No nos hacemos responsables por demoras o mal funcionamiento de los servicios de la compañía. 

El código de la aplicación se encuentra disponible bajo la licencia GPL3, cualquier tipo de copia, modificación y compilación del código deben hacerse respetando la licencia y bajo principios éticos, no se aceptarán contribuciones al código que traten de engañar a los usuarios o de exportar información de los mismos a servidores externos.

UNA VEZ MÁS. HACEMOS ÉNFASIS EN QUE LOS USUARIOS DEBEN DESCARGAR LA APLICACIÓN DESDE FUENTES OFICIALES:

FUENTES OFICIALES:

1. Releases generados automáticamente a partir del código oficial alojado en Github: 

https://github.com/todo-devs/todo/releases

Fecha de actualización: 22 de junio del 2020
""";
}

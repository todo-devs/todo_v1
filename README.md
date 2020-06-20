# TODO

Helper app to aid user with ETECSA services

## Instalación del entono de desarrollo

1. Clonar este repositorio

2. Instalar Flutter SDK https://flutter.dev/docs/get-started/install

3. Instalar dependencias

Dentro de la carpeta del proyecto

```bash
flutter pub get
```
4. Compilar y correr versión debug en dispositivo virtual o físico

Dentro de la carpeta del proyecto

```bash
flutter run
```

5. Compilar version release para android

Dentro de la carpeta del proyecto

```
flutter build apk --target-platform android-arm,android-arm64
```

### NOTAS: 
- Con la primera compilacion es necesario estar conectado y con VPN en caso que se encuentre en Cuba para que flutter descargue algunas dependencias extras.

## Estructura de archivos

El código de la aplicación se almacena bajo la carpeta `/lib` el resto de los archivos son archivos de configuración de flutter.

* `/lib/main.dart`

Punto de entrada de la aplicación (función main) que inicializa la aplicación

* `/lib/pages`

En esta carpeta se encuentra la implementación de los widgets mas generales que se muestran en la aplicación como una pagina completa.

* `/lib/components`

En esta carpeta se encuentra la implementació de los widgets especificos que se utilizan para una función determinada, estos son cargados por los widgets de `/lib/pages`

* `/lib/models`

Modelos para estructurar los datos que se almacenan en la app o se envian a servicios en la red.

* `/lib/services`

Servicios utilizados por la aplicación

* `/lib/services/ussd.dart`

Servicio encargado de lanzar codigos ussd

* `/config`

Archivos de configuración de la app

* `/config/ussd_codes.dart`

Listado de codigos ussd, se utiliza para mostrar el listado de widgets que permiten ejecutar los distintos codigos ussd.

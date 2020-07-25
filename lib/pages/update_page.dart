import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:apklis_api/models/apklis_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/services/permissions.dart';

class UpdatePage extends StatefulWidget {
  final ApklisItemModel model;

  const UpdatePage({Key key, @required this.model}) : super(key: key);

  @override
  UpdatePageState createState() => UpdatePageState();
}

class UpdatePageState extends State<UpdatePage> {
  static const PORT_NAME = 'downloader_send_port_todo';
  var port = ReceivePort();
  var progress = 0;
  var status = DownloadTaskStatus.undefined;
  var taskId = '';
  var url = '';
  var filename = '';
  var path = '';

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    url = 'https://archive.apklis.cu/application/'
        'apk/com.cubanopensource.todo-v'
        '${widget.model.lastRelease.versionCode}.apk';
    path = (await getExternalStorageDirectory()).path;
    filename = 'TODO '
        '${widget.model.lastRelease.versionName} Build '
        '${widget.model.lastRelease.versionCode}.apk';
    IsolateNameServer.registerPortWithName(port.sendPort, PORT_NAME);
    port.listen((dynamic data) {
      // String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {
        this.progress = progress;
        this.status = status;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(PORT_NAME);
    super.dispose();
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int p) {
    final SendPort send = IsolateNameServer.lookupPortByName(PORT_NAME);
    send.send([id, status, p]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Center(
                child: Text(
                  '¡¡¡ Nueva versión ${widget.model.lastRelease.versionName} !!!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Disponible en Apklis',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Center(
                      child: Html(
                        data: widget.model.lastRelease.changelog,
                        linkStyle: TextStyle(
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).focusColor,
                        ),
                        defaultTextStyle: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Opacity(
                  opacity: status == DownloadTaskStatus.running ? 1 : 0,
                  child: Text('$progress%'),
                ),
              ),
              Center(
                child: Opacity(
                  opacity: status == DownloadTaskStatus.running ? 1 : 0,
                  child: LinearProgressIndicator(
                    value: progress / 100,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  elevation: 0.5,
                  child: Text(
                    'Continuar sin actualizar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                child: MaterialButton(
                  onPressed: () async {
                    await action(status);
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  color: Theme.of(context).focusColor,
                  elevation: 0.5,
                  child: Text(
                    getText(status),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkStoragePermission() async {
    var hasPermission = await PermissionsService().hasStoragePermission();
    if (!hasPermission) {
      await showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            content: Text(
              'Para descargar una actualización de la aplicación se necesita '
              'permisos para utilizar el almacenamiento del dispositivo.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Continuar'),
                onPressed: () {
                  Navigator.of(_context).pop();
                },
              ),
            ],
          );
        },
      );
      var decision = await PermissionsService().requestStoragePermission();
      if (!decision) {
        return false;
      }
    }
    return true;
  }

  Future<void> action(DownloadTaskStatus status) async {
    if (status == DownloadTaskStatus.undefined ||
        status == DownloadTaskStatus.canceled ||
        status == DownloadTaskStatus.failed) {
      if (!await checkStoragePermission()) {
        return;
      }
      await FlutterDownloader.cancelAll();
      var id = await FlutterDownloader.enqueue(
        url: url,
        savedDir: path,
        fileName: filename,
        showNotification: false,
        openFileFromNotification: false,
      );
      setState(() {
        taskId = id;
      });
    } else if (status == DownloadTaskStatus.complete) {
      if (!await checkStoragePermission()) {
        return;
      }
      try {
        await showDialog(
          context: context,
          builder: (BuildContext _context) {
            return AlertDialog(
              content: Text(
                'Para instalar la actualización de la aplicación se necesita '
                'que se active la opción de instalar apps desde esta fuente.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Continuar'),
                  onPressed: () {
                    Navigator.of(_context).pop();
                  },
                ),
              ],
            );
          },
        );
        await InstallPlugin.installApk(
          '$path/$filename',
          'com.cubanopensource.todo',
        );
        Navigator.of(context).pop();
      } catch (e) {
        log('Exception in app installing:\n\n{e}');
      }
    } else if (status == DownloadTaskStatus.paused) {
      if (!await checkStoragePermission()) {
        return;
      }
      var id = await FlutterDownloader.resume(taskId: taskId);
      setState(() {
        taskId = id;
      });
    } else if (status == DownloadTaskStatus.running) {
      await FlutterDownloader.cancelAll();
    }
  }

  String getText(DownloadTaskStatus status) {
    if (status == DownloadTaskStatus.undefined ||
        status == DownloadTaskStatus.canceled) {
      return 'Descargar actualización';
    } else if (status == DownloadTaskStatus.complete) {
      return 'Instalar actualización';
    } else if (status == DownloadTaskStatus.paused) {
      return 'Continuar';
    } else if (status == DownloadTaskStatus.failed) {
      return 'Reintentar descargar actualización';
    } else if (status == DownloadTaskStatus.running ||
        status == DownloadTaskStatus.enqueued) {
      return 'Cancelar descarga';
    }
    return 'Salir';
  }
}

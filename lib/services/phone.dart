import 'dart:io';

import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;

import 'package:todo/services/permissions.dart';
import 'package:url_launcher/url_launcher.dart';

void callTo(String number) async {
  if (Platform.isAndroid) {
    if (!await PermissionsService()
        .hasPhonePermission()) if (!await PermissionsService().requestPhonePermission())
      return;

    android_intent.Intent()
      ..setAction(android_action.Action.ACTION_CALL)
      ..setData(Uri(scheme: "tel", path: number))
      ..startActivity().catchError((e) => print(e));
  } else if (Platform.isIOS) {
    final Uri _emailLaunchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    launch(_emailLaunchUri.toString());
  }
}

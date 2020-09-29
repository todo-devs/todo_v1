import 'package:flutter/services.dart';

const platform = const MethodChannel("todoappchannel_android");

Future<bool> getDrawPermissionState() async {
  bool drawPermission;

  try {
    final result = await platform.invokeMethod("getDrawPermissionState");
    drawPermission = result;
  } catch (e) {
    drawPermission = false;
  }

  return drawPermission;
}

Future<void> reqDrawPermission() async {
  if (!await getDrawPermissionState()) {
    try {
      await platform.invokeMethod("reqDrawPermission");
    } catch (e) {
      print(e.message);
    }
  }
}

Future<bool> getShowWidgetPreference() async {
  bool showWidget;

  try {
    final result = await platform.invokeMethod("getShowWidgetPreference");
    showWidget = result;
  } catch (e) {
    showWidget = false;
  }

  return showWidget;
}

Future<bool> getTurnOffWifiPreference() async {
  bool turnOff;

  try {
    final result = await platform.invokeMethod("getTurnOffWifiPreference");
    turnOff = result;
  } catch (e) {
    turnOff = false;
  }

  return turnOff;
}

Future<void> setFalseShowWidget() async {
  try {
    await platform.invokeMethod("setFalseShowWidget");
  } catch (e) {
    print(e.message);
  }
}

Future<void> setFalseTurnOffWifi() async {
  try {
    await platform.invokeMethod("setFalseTurnOffWifi");
  } catch (e) {
    print(e.message);
  }
}

Future<void> setTrueShowWidget() async {
  try {
    await platform.invokeMethod("setTrueShowWidget");
  } catch (e) {
    print(e.message);
  }
}

Future<void> setTrueTurnOffWifi() async {
  try {
    await platform.invokeMethod("setTrueTurnOffWifi");
  } catch (e) {
    print(e.message);
  }
}

Future<void> turnOnWifi() async {
  try {
    await platform.invokeMethod("turnOnWifi");
  } catch (e) {
    print(e.message);
  }
}

Future<void> turnOffWifi() async {
  try {
    await platform.invokeMethod("turnOffWifi");
  } catch (e) {
    print(e.message);
  }
}

Future<bool> isWifiEnabled() async {
  bool isEnable;

  try {
    final result = await platform.invokeMethod("isWifiEnabled");
    isEnable = result;
  } catch (e) {
    isEnable = false;
  }

  return isEnable;
}

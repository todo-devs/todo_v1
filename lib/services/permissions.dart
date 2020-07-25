import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }

    return false;
  }

  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
        await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }

  Future<bool> requestPhonePermission() async {
    return requestPermission(PermissionGroup.phone);
  }

  Future<bool> hasPhonePermission() async {
    return hasPermission(PermissionGroup.phone);
  }

  Future<bool> requestStoragePermission() async {
    return requestPermission(PermissionGroup.storage);
  }

  Future<bool> hasStoragePermission() async {
    return hasPermission(PermissionGroup.storage);
  }
}

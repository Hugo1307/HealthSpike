import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  List<Permission> allPermissions = [Permission.activityRecognition, Permission.location];

  List<Permission> mandatoryPermissions = [Permission.activityRecognition, Permission.location];

  void printPermissionCheck() {
    for (Permission permission in allPermissions) {
      if (kDebugMode) {
        permission.isGranted.then((value) =>
            debugPrint(permission.toString() + ' is ' + value.toString()));
      }
    }
  }

  Future<void> checkMandatoryPermissions() async {
    for (Permission permission in mandatoryPermissions) {
      await permission.request();
    }
  }

}

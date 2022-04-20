import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  List<Permission> allPermissions = [Permission.activityRecognition];

  List<Permission> mandatoryPermissions = [Permission.activityRecognition];

  void printPermissionCheck() {
    for (Permission permission in allPermissions) {
      if (kDebugMode) {
        permission.isGranted.then((value) =>
            debugPrint(permission.toString() + ' is ' + value.toString()));
      }
    }
  }

  void checkMandatoryPermissions() {
    for (Permission permission in mandatoryPermissions) {
      permission.request();
    }
  }

}

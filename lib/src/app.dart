import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_ui/src/commons/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
final GlobalKey globalKey = GlobalKey();

///
late SharedPreferences _preferences;

///
List<CameraDescription> _appCameras = <CameraDescription>[];

///
SharedPreferences get preferences => _preferences;

///
List<CameraDescription> get appCameras => _appCameras;

///
late BaseDeviceInfo _deviceInfo;

/// 设置信息
BaseDeviceInfo get deviceInfo => _deviceInfo;

///
Future<void> appInitialized() async {
  ///
  _preferences = await SharedPreferences.getInstance();

  ///
  final deviceInfoPlugin = DeviceInfoPlugin();
  _deviceInfo = await deviceInfoPlugin.deviceInfo;

  try {
    if (Platform.isAndroid || Platform.isIOS) {
      _appCameras = await availableCameras();
    }
  } on CameraException catch (e) {
    debugPrint(e.code);
    debugPrint(e.description);
  }
}

///
void hideToast() {
  Fluttertoast.cancel();
}

///
Future<bool?> showToast({
  required String msg,
  Toast? toastLength,
  int timeInSecForIosWeb = 1,
  double? fontSize,
  ToastGravity? gravity,
  Color? backgroundColor,
  Color? textColor,
}) {
  Utils.vibrateSuccess();
  return Fluttertoast.showToast(
    msg: msg,
    textColor: textColor ?? Colors.black,
    backgroundColor:
        backgroundColor ?? const Color.fromARGB(255, 170, 255, 174),
    toastLength: toastLength,
    gravity: gravity ?? ToastGravity.TOP,
  );
}

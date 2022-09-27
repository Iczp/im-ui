import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';

///
class MaxLogIdProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  static const String keyName = "maxLogId";

  late SharedPreferences _preferences;

  ///
  static double _maxLogId = 0;

  ///
  get maxLogId => _maxLogId;

  get sharedPreferences => _preferences;

  ///
  MaxLogIdProvider({double? maxLogId}) {
    if (maxLogId != null) {
      _maxLogId = maxLogId;
    } else {
      _maxLogId = getMaxLogId();
    }
  }

  ///
  static Future<void> setMaxLogId(double value) async {
    if (_maxLogId == value) {
      return;
    }
    _maxLogId = value;
    Logger().d('maxLogId:$_maxLogId');

    await preferences.setDouble(keyName, _maxLogId);
  }

  static double takeMaxLogId() {
    _maxLogId = _maxLogId + 0.000001;
    return _maxLogId;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<double>('maxLogId', _maxLogId));
  }

  ///
  static getMaxLogId() => preferences.getDouble(keyName);
}

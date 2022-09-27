import 'package:flutter/foundation.dart';

import '../app.dart';

/// -- by iczp.net 2022.8.29
class KeyboardProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  KeyboardProvider({double? keyboardHeight}) {
    if (keyboardHeight != null) {
      _keyboardHeight = keyboardHeight;
    } else {
      _keyboardHeight = getKeyboardHeight() ?? defaultHeight;
    }
  }

  ///
  static final _instance = KeyboardProvider();

  ///
  static KeyboardProvider get instance => _instance;

  ///
  static const double defaultHeight = 321;

  ///
  double _keyboardHeight = defaultHeight;

  static const String keyName = 'KeyboardProvider';

  ///
  get keyboardHeight => _keyboardHeight;

  ///
  void setKeyboardHeight(value) {
    if (_keyboardHeight == value) {
      return;
    }
    _keyboardHeight = value;
    if (_keyboardHeight <= 0) {
      _keyboardHeight = defaultHeight;
    }
    notifyListeners();
    preferences.setDouble(keyName, value);
  }

  ///
  static double? getKeyboardHeight() => preferences.getDouble(keyName);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<double>('keyboardHeight', _keyboardHeight));
  }
}

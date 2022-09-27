import 'package:flutter/foundation.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool

class ProcessProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  static final _instance = ProcessProvider();

  ///
  static ProcessProvider get instance => _instance;

  /// users
  final Map<String, double?> _processes = <String, double>{};

  ///
  Future<void> loadAsyncThing() async {
    notifyListeners();
  }

  /// [key] argument String
  /// The [value] argument can either be null for an indeterminate
  /// progress indicator, or a non-null value between 0.0 and 1.0 for a
  /// determinate progress indicator.
  void set(String key, double? value) {
    if (value == null) {
      _processes.remove(key);
    } else {
      _processes[key] = value;
    }
    notifyListeners();
  }

  ///
  void remove(String key) {
    _processes.remove(key);
    notifyListeners();
  }

  ///
  double? get(String key) => _processes[key];

  ///
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<Map<String, double?>>('processes', _processes));
  }
}

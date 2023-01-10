import 'package:flutter/foundation.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool

class SessionUnitProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  static final _instance = SessionUnitProvider();

  ///
  static SessionUnitProvider get instance => _instance;

  ///
  static final _sessionUnitMap = <String, SessionUnit>{};

  ///
  SessionUnit? get(String id) {
    return _sessionUnitMap[id];
  }

  ///
  void set(SessionUnit entity, {bool isNotify = true}) {
    _sessionUnitMap[entity.id] = entity;
    Logger().w('set:${_sessionUnitMap.length}');
    notifyListeners();
  }

  ///
  void setMany(List<SessionUnit> list) {
    for (var e in list) {
      set(e, isNotify: false);
    }
    Logger().w('setMany: ${_sessionUnitMap.keys.length}');
    notifyListeners();
  }

  ///
  List<SessionUnit> getList() {
    var list = _sessionUnitMap.values.toList();
    list.sort((a, b) => ((a.sorting ?? 0) - (b.sorting ?? 0)).toInt());
    list.sort(
        (a, b) => (a.lastMessageAutoId ?? 0) - (b.lastMessageAutoId ?? 0));
    Logger().w('getList: ${list.length}');
    return list;
  }

  ///
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // list all the properties of your class here.
    // See the documentation of debugFillProperties for more information.
    properties.add(DiagnosticsProperty<Map<String, SessionUnit>>(
        'sessionUnitMap', _sessionUnitMap));
  }
}

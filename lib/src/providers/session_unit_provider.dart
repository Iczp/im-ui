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
  final _sessionUnitMap = <String, SessionUnit>{};

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
    if (list.isEmpty) {
      Logger().d('setMany:list.isEmpty');
      return;
    }
    for (var e in list) {
      set(e, isNotify: false);
    }
    Logger().w(
        'listCount:${list.length},totalCount: ${_sessionUnitMap.keys.length}');
    notifyListeners();
  }

  ///
  List<SessionUnit> getList() {
    var list = _sessionUnitMap.values.toList();
    list.sort((a, b) => a.compareTo(b));
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

  void setBadge(String id, int? badge) {
    if (get(id)?.badge != null) {
      get(id)?.badge = null;
    } else {
      get(id)?.badge = badge;
    }
    notifyListeners();
  }

  int? getBadge(String id) => get(id)?.badge;

  int? getReadedMessageAutoId(String id) => get(id)?.readedMessageAutoId;

  Future setReaded({
    required String id,
    required String messageId,
    required double messageAutoId,
  }) async {
    var entity = get(id);
    if (entity == null) {
      Logger().e('No such entity[SessionUnit]:$id');
      return;
    }
    if (entity.readedMessageAutoId == messageAutoId) {
      Logger().w('No change required [readedMessageAutoId]:$messageAutoId');
      return;
    }
    SessionUnitSetReaded(id: id, messageId: messageId)
        .submit()
        .whenComplete(() {
      entity.readedMessageAutoId = messageAutoId.toInt();
      setBadge(id, 0);
    });
  }
}

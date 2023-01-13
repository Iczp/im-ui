import 'package:flutter/foundation.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/providers.dart';
import 'package:logger/logger.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool

class SessionUnitProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  static final _instance = SessionUnitProvider();

  ///
  static SessionUnitProvider get instance => _instance;

  ///
  final _sessionUnitMap = <String, SessionUnit>{};

  final _maxAutoIdMap = <String, int>{};

  late int _maxAutoId = 0;

  ///
  SessionUnit? get(String id) {
    return _sessionUnitMap[id];
  }

  ///
  void set(SessionUnit entity, {bool isNotify = true}) {
    _sessionUnitMap[entity.id] = entity;
    setMaxAutoId(entity.lastMessageAutoId ?? 0);
    // Logger().w('set:${_sessionUnitMap.length}');
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
    Logger().d(
        'setReaded:id:$id,messageId:$messageId,messageAutoId:$messageAutoId');
    var entity = get(id);
    if (entity == null) {
      Logger().e('No such entity[SessionUnit]:$id');
      return;
    }
    if (entity.readedMessageAutoId == messageAutoId && entity.badge == 0) {
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

  void setMaxAutoId(int value) {
    if (value > _maxAutoId) {
      _maxAutoId = value;
      Logger().d('setMaxAutoId:$_maxAutoId');
    }
  }

  int getMaxAutoId() {
    var maxItem = _sessionUnitMap.values.toList().reduce((curr, next) {
      var currAutoId = curr.lastMessageAutoId ?? 0;
      var nextAutoId = next.lastMessageAutoId ?? 0;
      return currAutoId > nextAutoId ? curr : next;
    });
    return maxItem.lastMessageAutoId ?? 0;
  }

  Future fetchNewSession() async {
    var ret = await SessionUnitGetList(
      ownerId: ChatObjectProvider.instance.currentId,
      minAutoId: _maxAutoId,
      maxResultCount: 20,
    ).submit();

    setMany(ret.items);
    ChatObjectProvider.instance.setMany(ret.items
        .where((x) => x.destination != null)
        .map((e) => e.destination!)
        .toList());
  }
}

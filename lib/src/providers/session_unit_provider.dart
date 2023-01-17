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

  DateTime? getSendTime(id) => get(id)?.lastMessage?.creationTime;

  String? getRename(String id) => get(id)?.rename;

  bool getImmersed(String id) => get(id)?.isImmersed ?? false;

  bool getTopping(String id) => get(id)?.isTopping ?? false;

  MessageDto? getLastMessage(String id) => get(id)?.lastMessage;

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
    SessionUnitSetReaded(
      id: id,
      messageId: messageId,
    ).submit().then((ret) => set(ret)).whenComplete(() {
      // entity.readedMessageAutoId = messageAutoId.toInt();
      // setBadge(id, 0);
    });
  }

  void setMaxAutoId(int value) {
    if (value > _maxAutoId) {
      _maxAutoId = value;
      Logger().d('setMaxAutoId:$_maxAutoId');
    }
  }

  int getMaxAutoId() {
    var maxItem = _sessionUnitMap.values.max((x) => x.lastMessageAutoId);
    return maxItem?.lastMessageAutoId ?? 0;
  }

  void _fetchDataHander(List<SessionUnit> items) {
    setMany(items);
    ChatObjectProvider.instance.setMany(items
        .where((x) => x.destination != null)
        .map((e) => e.destination!)
        .toList());
  }

  Future fetchNew({required String ownerId, int maxResultCount = 20}) async {
    var ret = await SessionUnitGetList(
      ownerId: ownerId,
      minAutoId: _maxAutoId,
      maxResultCount: maxResultCount,
    ).submit();
    _fetchDataHander(ret.items);
    //loop
    if (ret.items.length == maxResultCount) {
      await fetchNew(ownerId: ownerId, maxResultCount: maxResultCount);
    }
  }

  Future fetchMore({
    required String ownerId,
  }) async {
    var ret = await SessionUnitGetList(
      ownerId: ownerId,
      skipCount: _sessionUnitMap.length,
      maxResultCount: 100,
    ).submit();
    _fetchDataHander(ret.items);
  }

  Future<void> toggleImmersed({required String id}) async {
    var isImmersed = get(id)!.isImmersed;
    var entity =
        await SessionUnitSetImmersed(id: id, isImmersed: !isImmersed).submit();
    set(entity);
  }

  Future<void> toggleTopping({required String id}) async {
    var isTopping = get(id)!.sorting != 0;
    var entity =
        await SessionUnitSetTopping(id: id, isTopping: !isTopping).submit();
    set(entity);
  }
}

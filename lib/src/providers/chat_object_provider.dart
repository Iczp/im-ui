import 'package:flutter/foundation.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool

class ChatObjectProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  static final _instance = ChatObjectProvider();

  ///
  static ChatObjectProvider get instance => _instance;

  ///
  final _chatObjectMap = <String, ChatObject>{};

  ///
  final _currentMap = <String, bool>{};

  ///
  String get currentId => 'b700aef5-d48b-4aac-9bbe-52fdcdfd53cb';

  ///
  late ChatObject? _current;

  ///
  ChatObject? get current => _current;

  ///
  ChatObject? getCurrent() {
    var item = _currentMap.entries.toList().firstOrNull((x) => x.value);
    if (item == null) {
      return null;
    }
    return get(item.key);
  }

  ///
  List<ChatObject> getCurrentList() {
    var list = <ChatObject>[];
    for (var item in _currentMap.entries) {
      var chatObject = get(item.key);
      if (chatObject != null) {
        list.add(chatObject);
      }
    }
    return list;
  }

  ///
  void setCurrent(String chatObjectId) {
    for (var key in _currentMap.keys) {
      _currentMap[key] = false;
    }
    _currentMap[chatObjectId] = true;
    _current = get(chatObjectId);
  }

  ///
  ChatObject? get(String id) {
    return _chatObjectMap[id];
  }

  ///
  void set(ChatObject entity) {
    _chatObjectMap[entity.id] = entity;
    notifyListeners();
  }

  ///
  void setMany(List<ChatObject> list) {
    for (var e in list) {
      set(e);
    }
    // Logger()
    //     .d('setMany count:${list.length},totalCount:${_chatObjectMap.length}');
  }

  ///
  List<ChatObject> getList() {
    var list = _chatObjectMap.values.toList();
    return list;
  }
}
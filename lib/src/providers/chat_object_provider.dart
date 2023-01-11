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
    Logger()
        .d('setMany count:${list.length},totalCount:${_chatObjectMap.length}');
  }

  ///
  List<ChatObject> getList() {
    var list = _chatObjectMap.values.toList();
    return list;
  }
}

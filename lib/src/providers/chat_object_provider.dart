import 'package:flutter/foundation.dart';
import 'package:im_core/im_core.dart';

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
  }

  ///
  void setMany(List<ChatObject> list) {
    list.map((e) => set(e));
  }

  ///
  List<ChatObject> getList() {
    var list = _chatObjectMap.values.toList();
    return list;
  }
}

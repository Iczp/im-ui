import 'package:flutter/foundation.dart';
import 'package:im_core/im_core.dart';

import '../models/result_model.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool

class MessageProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  static final _instance = MessageProvider();

  ///
  static MessageProvider get instance => _instance;

  /// <sessionUnitId,List<MessageDto>>{}
  static final _sessionMessages = <String, List<MessageDto>>{};

  ///
  void append(String sessionUnitId, MessageDto message) {
    if (!_sessionMessages.containsKey(sessionUnitId)) {
      _sessionMessages[sessionUnitId] = <MessageDto>[];
    }
    _sessionMessages[sessionUnitId]!.add(message);
    notifyListeners();
  }

  static List<MessageDto> getMessages(
    String sessionUnitId, {
    int? maxCount,
    bool reversed = false,
  }) {
    var list = _sessionMessages[sessionUnitId] ?? <MessageDto>[];
    if (reversed) {
      list = list.reversed.toList();
    }

    if (maxCount == null || list.isEmpty) {
      return list;
    }

    ///
    if (reversed) {
      if (list.length < maxCount) {
        return list.sublist(0, list.length);
      }
      return list.sublist(0, maxCount);
    } else {
      if (list.length > maxCount) {
        return list.sublist(list.length - maxCount);
      }
      return list.sublist(0, list.length);
    }
  }

  void setMessages(String sessionUnitId, List<MessageDto> messageList) {
    _sessionMessages[sessionUnitId] = messageList;
    // notifyListeners();
  }

  ///
  ResultModel updateMessage(String sessionUnitId, MessageDto message) {
    if (_sessionMessages[sessionUnitId] == null) {
      return ResultModel(
        isSuccess: false,
        message: '消息为null,sessionUnitId:$sessionUnitId',
      );
    }

    var item = _sessionMessages[sessionUnitId]
        ?.singleWhere((x) => x.globalKey == message.globalKey);
    if (item == null) {
      return ResultModel(
        isSuccess: false,
        message:
            '未找到消息,sessionUnitId:$sessionUnitId,message.globalKey:${message.globalKey}',
      );
    }
    var index = _sessionMessages[sessionUnitId]!.indexOf(item);
    _sessionMessages[sessionUnitId]![index] = item;
    return ResultModel(isSuccess: true);
  }

  List<MessageDto> getSessionMessages(String sessionUnitId) =>
      _sessionMessages[sessionUnitId] ?? <MessageDto>[];
}

import 'package:flutter/foundation.dart';
import 'package:im_core/im_core.dart';

import '../models/result_model.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool

class MessageProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  static final MessageProvider _instance = MessageProvider();

  ///
  static MessageProvider get instance => _instance;

  static final _sessionMessages = <String, List<MessageDto>>{};

  ///
  void append(String sessionId, MessageDto message) {
    if (!_sessionMessages.containsKey(sessionId)) {
      _sessionMessages[sessionId] = <MessageDto>[];
    }
    _sessionMessages[sessionId]!.add(message);
    notifyListeners();
  }

  static List<MessageDto> getMessages(
    String sessionId, {
    int? maxCount,
    bool reversed = false,
  }) {
    var list = _sessionMessages[sessionId] ?? <MessageDto>[];
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

  void setMessages(String sessionId, List<MessageDto> messageList) {
    _sessionMessages[sessionId] = messageList;
    // notifyListeners();
  }

  ///
  ResultModel updateMessage(String sessionId, MessageDto message) {
    if (_sessionMessages[sessionId] == null) {
      return ResultModel(
        isSuccess: false,
        message: '消息为null,sessionId:$sessionId',
      );
    }

    var item = _sessionMessages[sessionId]
        ?.singleWhere((x) => x.globalKey == message.globalKey);
    if (item == null) {
      return ResultModel(
        isSuccess: false,
        message:
            '未找到消息,sessionId:$sessionId,message.globalKey:${message.globalKey}',
      );
    }
    var index = _sessionMessages[sessionId]!.indexOf(item);
    _sessionMessages[sessionId]![index] = item;
    return ResultModel(isSuccess: true);
  }

  List<MessageDto> getSessionMessages(String sessionId) =>
      _sessionMessages[sessionId] ?? <MessageDto>[];
}

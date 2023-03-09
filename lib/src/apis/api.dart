import 'dart:async';
import 'dart:math';
// import 'package:dio/dio.dart';

import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';

import '../providers/max_log_id_provider.dart';
import '../providers/process_provide.dart';

class Api {
  ///
  Api();

  ///
  Future<MessageDto> sendMessage(
    String? sessionId,
    MessageDto message,
    void Function()? callback,
  ) async {
    Logger().d('sessionId:$sessionId,logid:${message.autoId}');
    await Future.delayed(Duration(milliseconds: Random().nextInt(2000) + 500));
// var dio = Dio();
// CancelToken token = CancelToken();
// Response  response = await dio.get('/test?id=12&name=wendu');

    ///
    message.setMessageState(MessageStateEnum.success);
    var logId = (message.autoId!.toInt() + Random().nextInt(10)).toDouble();
    message.setLogId(logId);
    await MaxLogIdProvider.setMaxLogId(logId);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      Logger().e('message*****************************');
      timer.cancel();
      ProcessProvider.instance.set('123456', Random().nextDouble());
      callback?.call();
    });
    return message;
  }
}

var api = Api();

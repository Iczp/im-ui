import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/io.dart';

import '../commons/reg.dart';

class WebSocketController {
  final _controller = StreamController<PushPayload>();

  void connect() {
    var wsUrl =
        'ws://10.0.5.20:31230/ws?ticket=360cfedb-e92d-3331-1fad-3a086371e0e4';
    final channel = IOWebSocketChannel.connect(
      wsUrl,
      pingInterval: const Duration(seconds: 3),
      connectTimeout: const Duration(seconds: 30),
    );

    Logger().e('wsUrl:$wsUrl');

    channel.sink.add('wsUrl------------:$wsUrl');

    Timer.periodic(const Duration(seconds: 5), (timer) {
      channel.sink.add(DateTime.now().microsecondsSinceEpoch.toString());
    });

    var subscription = channel.stream.listen((message) async {
      debugPrint('received:$message');
      // channel.sink.add('received!');

      bool isJson = Reg.isJson(message);

      if (isJson) {
        var json = jsonDecode(message);
        var pushPayload = PushPayload.fromJson(json);
        Logger().w('pushPayload:${pushPayload.payload}');
        Logger().w('command:${pushPayload.command}');
      }

      Logger().w('runtimeType:${message.runtimeType}');

      // await channel.sink.close(status.goingAway);

      // channel.sink.add('**************====******************');
    }, onDone: () {
      debugPrint('ws channel closed');
      Logger().w('onDone');
    }, onError: (e) {
      Logger().e('onError');
      debugPrint('Connection exception $e');
    });

    // subscription.cancel();
  }
}

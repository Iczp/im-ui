library im_ui;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:im_core/services.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'providers.dart';
import 'src/app.dart';

export 'widgets.dart';

class ImUi {
  static final GlobalKey _globalKey = GlobalKey();
  static GlobalKey get globalKey => _globalKey;

  ///
  static void initialized() {
    appInitialized();
    HttpHelper.init(
      baseUrl: 'http://10.0.5.20:8044',
    );

    var wsUrl = 'ws://10.0.5.20:31230/ws';
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

    channel.stream.listen((message) {
      // channel.sink.add('received!');

      Logger().e('received:$message');
      debugPrint('received:$message');
      // channel.sink.close(status.goingAway);
    }, onDone: () {
      debugPrint('ws channel closed');
      Logger().e('onDone');
    }, onError: (e) {
      Logger().e('onError');
      debugPrint('Connection exception $e');
    });
  }

  ///
  static List<SingleChildWidget>? _providies;

  ///
  static List<SingleChildWidget> get providies => _providies ??= [
        ChangeNotifierProvider(create: (_) => UsersProvider.instance),
        ChangeNotifierProvider(create: (_) => MessageProvider.instance),
        ChangeNotifierProvider(create: (_) => KeyboardProvider.instance),
        ChangeNotifierProvider(create: (_) => MaxLogIdProvider.instance),
        ChangeNotifierProvider(create: (_) => ProcessProvider.instance),
        ChangeNotifierProvider(create: (_) => ReadedRecordProvider.instance),
        ChangeNotifierProvider(create: (_) => ScrollProvider.instance),
        ChangeNotifierProvider(create: (_) => SessionUnitProvider.instance),
        ChangeNotifierProvider(create: (_) => ChatObjectProvider.instance),
      ];
}

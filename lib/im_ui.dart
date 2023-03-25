library im_ui;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/src/commons/reg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:im_core/extensions.dart';
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
    HttpHelper.init(HttpConfig(
      apiHost: 'http://10.0.5.20:8044',
      authHost: 'http://10.0.5.20:8043',
      clientId: 'IM_App',
      clientSecret: null,
      username: 'admin',
      password: '1q2w3E*',
    ));

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

    channel.stream.listen((message) async {
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
  }

  ///
  static List<SingleChildWidget>? _providies;

  ///
  static List<SingleChildWidget> get providies => _providies ??= [
        ChangeNotifierProvider(create: (_) => UserProvider.instance),
        ChangeNotifierProvider(create: (_) => MessageProvider.instance),
        ChangeNotifierProvider(create: (_) => KeyboardProvider.instance),
        ChangeNotifierProvider(create: (_) => MaxLogIdProvider.instance),
        ChangeNotifierProvider(create: (_) => ProcessProvider.instance),
        ChangeNotifierProvider(create: (_) => ReadedRecordProvider.instance),
        ChangeNotifierProvider(create: (_) => ScrollProvider.instance),
        ChangeNotifierProvider(create: (_) => SessionUnitProvider.instance),
        ChangeNotifierProvider(create: (_) => ChatObjectProvider.singleton),
      ];
}

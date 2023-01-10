library im_ui;

import 'package:flutter/cupertino.dart';
import 'package:im_ui/src/providers/chat_object_provider.dart';
import 'package:im_ui/src/providers/session_unit_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:im_core/services.dart';
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
  }

  ///
  static List<SingleChildWidget>? _providies;

  ///
  static List<SingleChildWidget> get providies => _providies ??= [
        ChangeNotifierProvider(create: (_) => UsersProvide.instance),
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

library im_ui;

import 'package:im_ui/providers.dart';
import 'package:im_ui/src/app.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

export 'widgets.dart';

class ImUi {
  static void initialized() {
    appInitialized();
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
      ];
}

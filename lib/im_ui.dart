library im_ui;

import 'package:im_ui/providers.dart';
import 'package:im_ui/src/app.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

export 'src/widgets.dart';

class ImUi {
  static void initialized() {
    appInitialized();
  }

  ///
  static List<SingleChildWidget> initProviders() {
    return [
      ChangeNotifierProvider(create: (_) => UsersProvide()),
      ChangeNotifierProvider(create: (_) => MessageProvider.instance),
      ChangeNotifierProvider(create: (_) => KeyboardProvider()),
      ChangeNotifierProvider(create: (_) => MaxLogIdProvider()),
      ChangeNotifierProvider(create: (_) => ProcessProvider.instance),
      ChangeNotifierProvider(create: (_) => ReadedRecordProvider()),
      ChangeNotifierProvider(create: (_) => ScrollProvider()),
    ];
  }
}

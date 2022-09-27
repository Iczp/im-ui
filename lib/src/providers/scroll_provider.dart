import 'package:flutter/foundation.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool

class ScrollModel {
  ScrollModel({
    required this.maxScrollExtent,
    required this.currentPixels,
  });

  final double maxScrollExtent;
  final double currentPixels;
}

/// 消息已读标记
class ScrollProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  ScrollProvider() {
    ///
  }

  ///
  static final _instance = ScrollProvider();

  ///
  static ScrollProvider get instance => _instance;

  ///
  final _scrollMaps = <String, ScrollModel>{};

  ///
  void storageScroll(String sessionId, ScrollModel scrollModel) {
    _scrollMaps[sessionId] = scrollModel;
  }

  ScrollModel? getScroll(String sessionId) => _scrollMaps[sessionId];

  /// Makes `_readedMaps` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<String, ScrollModel>>(
        '_readedMaps', _scrollMaps));
  }
}

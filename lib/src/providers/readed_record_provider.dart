import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';

///
class ReadedRecordModel {
  ReadedRecordModel(this.autoId, this.globalKey);
  final double autoId;
  final GlobalKey? globalKey;

  ///

  ReadedRecordModel.fromJson(Map<String, dynamic> json)
      : autoId = json['logId'],
        globalKey = null;

  ///
  Map<String, dynamic> toJson() => {
        'logId': autoId,
        'globalKey': globalKey.toString(),
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
/// 消息已读标记
class ReadedRecordProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  ReadedRecordProvider() {
    ///
  }

  ///
  ReadedRecordProvider.init(List<ReadedDto> readedList) {
    /// readed
    for (var x in readedList) {
      _readedMaps[x.sessionId!] = ReadedRecordModel(x.autoId!, null);
    }
  }

  ///
  static final _instance = ReadedRecordProvider();

  ///
  static ReadedRecordProvider get instance => _instance;

  ///
  final _readedMaps = <String, ReadedRecordModel>{};

  ///
  void setReaded(String sessionUnitId, double logId, GlobalKey? globalKey) {
    var readedRecordModel = ReadedRecordModel(logId, globalKey);
    _readedMaps[sessionUnitId] = readedRecordModel;
    notifyListeners();
    Logger().w('ReadedProvider.setReaded sessionUnitId:$sessionUnitId');
    Logger().w(readedRecordModel);
  }

  ReadedRecordModel? getReaded(String sessionUnitId) =>
      _readedMaps[sessionUnitId];

  /// Makes `_readedMaps` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<String, ReadedRecordModel>>(
        '_readedMaps', _readedMaps));
  }
}

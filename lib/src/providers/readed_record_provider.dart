import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';

///
class ReadedRecordModel {
  ReadedRecordModel(this.logId, this.globalKey);
  final double logId;
  final GlobalKey? globalKey;

  ///

  ReadedRecordModel.fromJson(Map<String, dynamic> json)
      : logId = json['logId'],
        globalKey = null;

  ///
  Map<String, dynamic> toJson() => {
        'logId': logId,
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
      _readedMaps[x.sessionId!] = ReadedRecordModel(x.logId!, null);
    }
  }

  ///
  final _readedMaps = <String, ReadedRecordModel>{};

  ///
  void setReaded(String sessionId, double logId, GlobalKey? globalKey) {
    var readedRecordModel = ReadedRecordModel(logId, globalKey);
    _readedMaps[sessionId] = readedRecordModel;
    notifyListeners();
    Logger().w('ReadedProvider.setReaded sessionId:$sessionId');
    Logger().w(readedRecordModel);
  }

  ReadedRecordModel? getReaded(String sessionId) => _readedMaps[sessionId];

  /// Makes `_readedMaps` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<String, ReadedRecordModel>>(
        '_readedMaps', _readedMaps));
  }
}

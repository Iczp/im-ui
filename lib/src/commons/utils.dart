import 'dart:developer';
import 'dart:io';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:im_core/enums.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

/// 格式化时间
String formatDuration(int milliseconds) {
  Duration duration = Duration(milliseconds: milliseconds);
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours == 0) {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

/// 格式化文件大小
String formatSize(dynamic size, [int round = 2]) {
  return filesize(size, round);
}

String formatTime(DateTime dateTime) {
  // Logger().d('dateTime.weekday:${dateTime.weekday}');

  var now = DateTime.now();
  var thisWeekStart = now.add(Duration(days: -now.weekday));

  var diff = now.difference(dateTime);
  // Logger().d('diff: ${thisWeekStart.difference(dateTime).inDays}');
  //今天
  if (diff.inDays == 0) {
    if (diff.inMinutes < 3) {
      return '刚刚${DateFormat("HH:mm").format(dateTime)}';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分前';
    }
    if (diff.inHours < 3) {
      return '${diff.inHours}小时前 ${DateFormat("HH:mm").format(dateTime)}';
    }
    return DateFormat("HH:mm").format(dateTime);
  }
  // 昨天
  if (diff.inDays == 1) {
    return DateFormat("昨天 HH:mm").format(dateTime);
  }
  //本周
  if (thisWeekStart.difference(dateTime).inDays < 0) {
    var week = $WeekConsts[dateTime.weekday]!;
    return '$week ${DateFormat("HH:mm").format(dateTime)}';
  }
  //上周
  if (thisWeekStart.difference(dateTime).inDays < 7) {
    var week = $WeekConsts[dateTime.weekday]!;
    return '上$week ${DateFormat("HH:mm").format(dateTime)}';
  }
  if (dateTime.year == now.year) {
    return DateFormat("MM月dd日 HH:mm").format(dateTime);
  }

  return DateFormat("yyy-MM-dd HH:mm").format(dateTime);
}

class Utils {
  ///振动
  static void vibrate() {
    log('vibrate');
    if (Platform.isAndroid || Platform.isIOS) {
      // Vibrate.vibrate();
      // Vibrate.vibrateWithPauses([
      //   const Duration(milliseconds: 500),
      // ]);
      Vibrate.feedback(FeedbackType.success);
    } else {
      log('vibrate **');
    }
  }

  ///振动反馈
  static void vibrateFeedBack(FeedbackType feedbackType) {
    if (Platform.isAndroid || Platform.isIOS) {
      // Vibrate.vibrate();
      // Vibrate.vibrateWithPauses([
      //   const Duration(milliseconds: 500),
      // ]);
      Vibrate.feedback(feedbackType);
    } else {
      Logger().w('feedback $feedbackType');
    }
  }

  ///振动反馈: sussess
  static void vibrateSuccess() {
    vibrateFeedBack(FeedbackType.success);
  }

  ///振动反馈: sussess
  static void vibrateIfSuccess(VoidCallback? callback) {
    if (callback != null) {
      callback();
      vibrateFeedBack(FeedbackType.success);
    }
  }

  ///振动反馈: error
  static void vibrateError() {
    vibrateFeedBack(FeedbackType.error);
  }

  static bool isToday(DateTime dateTime, {DateTime? dateTime2}) {
    var now = dateTime2 ?? DateTime.now();
    var diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(dateTime.year, dateTime.month, dateTime.day));

    return diff.inDays == 0;
  }

  static bool isCurrentWeek(DateTime dateTime) {
    var now = DateTime.now();
    var thisWeekStart = now.add(Duration(days: -now.weekday));

    Logger().d('inDays:${dateTime.difference(thisWeekStart).inDays}');

    return dateTime.difference(thisWeekStart).inDays >= 0;
  }
}

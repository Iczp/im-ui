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

String hourText(int hour) {
  if (hour < 6) {
    return '凌晨';
  } else if (hour < 12) {
    return '上午';
  } else if (hour < 14) {
    return '中午';
  } else if (hour < 18) {
    return '下午';
  } else if (hour < 24) {
    return '晚上';
  }
  return '';
}

String formatTime(DateTime dateTime) {
  // Logger().d('dateTime.weekday:${dateTime.weekday}');

  var now = DateTime.now();
  var thisWeekStart = now.add(Duration(days: -now.weekday));

  var diff = now.difference(dateTime);
  // Logger().d('diff: ${thisWeekStart.difference(dateTime).inDays}');
  //今天
  if (diff.inDays == 0 && now.day == dateTime.day) {
    if (diff.inMinutes < 1) {
      return '刚刚';
    }
    if (diff.inMinutes == 30) {
      return '半小时前';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    }
    if (diff.inHours < 3) {
      return '${diff.inHours}小时前 ${DateFormat("HH:mm").format(dateTime)}';
    }
    return DateFormat("${hourText(dateTime.hour)} HH:mm").format(dateTime);
  }
  // 昨天
  if (now.add(const Duration(days: -1)).day == dateTime.day) {
    return DateFormat("昨天${hourText(dateTime.hour)} HH:mm").format(dateTime);
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
  //本月
  if (dateTime.year == now.year && dateTime.month == now.day) {
    return DateFormat("dd日${hourText(dateTime.hour)} HH:mm").format(dateTime);
  }
  //今年
  if (dateTime.year == now.year) {
    return DateFormat("MM月dd日${hourText(dateTime.hour)} HH:mm")
        .format(dateTime);
  }
  return DateFormat("yyyy年MM月dd日").format(dateTime);
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

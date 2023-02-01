import 'package:flutter/cupertino.dart';
import 'package:im_core/entities.dart';
import 'package:im_core/enums.dart';

import '../pages/chating_page.dart';

class Nav {
  ///
  static Future toChat(
    BuildContext context, {
    String? title,
    required String sessionUnitId,
  }) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          // return ChatPage();
          return ChatingPage(
            title: title ?? sessionUnitId,
            media: const MediaInput.build('zhongpei', MediaTypeEnum.personal),
            sessionUnitId: sessionUnitId,
          );
        },
      ),
    );
  }
}

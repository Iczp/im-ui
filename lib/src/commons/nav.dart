import 'package:flutter/cupertino.dart';
import 'package:im_core/entities.dart';
import 'package:im_core/enums.dart';
import 'package:im_ui/im_ui.dart';

import '../../chating_page.dart';

class Nav {
  ///
  static void toChat(BuildContext context) {
    print('ImUi.globalKey.currentContext:${ImUi.globalKey.currentContext}');

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          // return ChatPage();
          return const ChatingPage(
            title: 'title',
            media: MediaInput.build('zhongpei', MediaTypeEnum.personal),
          );
        },
      ),
    );
  }
}

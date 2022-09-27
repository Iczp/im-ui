import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';

import 'function_button.dart';

class ContactsFunctionButton extends FunctionButton<ContactsContentDto> {
  ///

  ///
  const ContactsFunctionButton({
    super.key,
    super.onSend,
  });

  @override

  ///
  @override
  String get text => '名片';

  ///
  @override
  IconData get icon => Icons.contact_mail_rounded;

  ///
  @override
  State<ContactsFunctionButton> createState() => ContactsFunctionButtonState();
}

class ContactsFunctionButtonState<T extends FunctionButton>
    extends FunctionButtonState<T> {
  ///
  @override
  void onTap() {
    Logger().d('ContactsFunctionButton');

    // Navigator.push(
    //     context,
    //     CupertinoPageRoute(
    //       builder: (context) => const ContactsPage(
    //         title: '',
    //       ),
    //     ));
  }
}

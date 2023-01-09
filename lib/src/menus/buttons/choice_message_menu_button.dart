import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';
import '../../messages/list_view/message_list_view.dart';
import 'message_menu_button.dart';

class ChoiceMessageMenuButton extends MessageMenuButton {
  ///
  const ChoiceMessageMenuButton(super.arguments, {super.key});

  ///
  @override
  String get text => '多选';

  ///
  @override
  IconData get icon => Icons.checklist_rtl_sharp;

  @override
  State<ChoiceMessageMenuButton> createState() =>
      _ChoiceMessageMenuButtonState();
}

class _ChoiceMessageMenuButtonState
    extends MessageMenuButtonState<ChoiceMessageMenuButton> {
  ///
  MessageListViewState? getListViewKey() {
    var key = widget.arguments.listViewKey as GlobalKey;
    return key.state<MessageListViewState>();
  }

  MessageListViewState? get listViewKey => getListViewKey();

  ///
  @override
  void onTap() {
    Logger().i('${toString()} - ${message.messageType}');
    super.onTap();

    listViewKey?.setChoiceMode(ChoiceModeEnum.multiple);
    Logger().w(listViewKey);

    //
  }
}

import 'package:flutter/widgets.dart';

import 'package:im_core/im_core.dart';

import '../menus/message_menu_dialog.dart';
import '../menus/menu_button.dart';

/// 消息长按
typedef GlobalKeyCallback = void Function(GlobalKey);

///头像长按
typedef MediaAvatarLongPressCallback = void Function(
    GlobalKey, LayerLink, bool?);

///头像长按
typedef MenuTapCallback = void Function(MenuButton);

/// 消息部件参数
class MessageArguments {
  ///
  final GlobalKey? chatInputKey;

  static const double marginAll = 8;

  static const double mediaSize = 48;

  /// 是否显示发送时间
  final bool isSendTimeDisplay;

  /// 是否显示用户头像
  final bool isMediaAvatarDisplay;

  /// 是否显示用户名称
  final bool isMediaNameDisplay;

  /// 引用消息点击事件
  final VoidCallback? onQuoteMessageTap;

  /// 头像长按事件
  final MediaAvatarLongPressCallback? onMediaLongPress;

  // /// 消息内容主键
  // final GlobalKey messageBodyKey;

  /// 消息
  final MessageDto message;

  ///语音播放
  final bool isSoundPlay;

  ///消息是否为已读
  final bool isReaded;

  ///消息长按
  final GlobalKeyCallback? onMessageLongPress;

  ///消息点击
  final GestureTapCallback? onMessageTap;

  ///
  final GlobalKey<MessageMenuDialogState>? messageDialogKey;

  // ///
  // final MenuTapCallback? onMenuTap;

  ///选择模式
  final ChoiceModeEnum? choiceMode;

  /// 选择状态变化
  final ValueChanged<bool>? onMessageChanged;

  ///是否选择 （选择模式时使用）
  final bool isChecked;

  ///消息列表 GlobalKey
  final Key? listViewKey;

  ///
  final MediaInput media;

  ///
  final bool isShowSendTime;

  ///
  MessageArguments({
    this.messageDialogKey,
    required this.message,
    this.isReaded = false,
    required this.isSoundPlay,
    // required this.messageBodyKey,

    this.choiceMode,
    this.isSendTimeDisplay = true,
    this.isMediaAvatarDisplay = true,
    this.isMediaNameDisplay = true,
    this.onQuoteMessageTap,
    this.onMediaLongPress,
    this.onMessageLongPress,
    this.onMessageTap,
    // this.onMenuTap,
    this.onMessageChanged,
    this.isChecked = false,
    this.chatInputKey,
    this.listViewKey,
    required this.media,
    required this.isShowSendTime,
  });

  ///
  bool get isChoiceMode => choiceMode != null;
}

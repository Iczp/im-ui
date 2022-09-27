import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';

import '../../chat_page/widget/message_list_view.dart';
import '../../commons/utils.dart';
import '../../message_viewer/message_viewer_page.dart';
import '../../models/message_arguments.dart';
import '../../chat_input/chat_input.dart';
import '../choice_container.dart';
import '../../medias/media_avatar.dart';
import '../../medias/media_name_widget.dart';
import '../message_menu_buttons_all.dart';
import 'message_preview.dart';
import 'message_sendtime_widget.dart';
import 'message_state_widget.dart';

/// 消息组件
abstract class MessageWidget<TMessage extends MessageDto>
    extends StatefulWidget {
  MessageWidget({
    Key? key,
    required this.arguments,
  }) : super(key: arguments.message.globalKey);

  ///消息参数
  final MessageArguments arguments;

  ///
  TMessage get message => arguments.message as TMessage;

  ///引用消息
  MessageDto? get quoteMessage => message.quoteMessage;

  ///是否自己
  bool get isSelf => arguments.message.isSelf();

  ///语音播放
  bool get isSoundPlay => arguments.isSoundPlay;

  ///消息长按
  GlobalKeyCallback? get onMessageLongPress => arguments.onMessageLongPress;

  ///消息点击
  GestureTapCallback? get onMessageTap => arguments.onMessageTap;

  ///
  bool get isSendTimeDisplay => arguments.isSendTimeDisplay;

  ///
  bool get isMediaAvatarDisplay => arguments.isMediaAvatarDisplay;

  ///
  bool get isMediaNameDisplay => arguments.isMediaNameDisplay;

  ///
  VoidCallback? get onQuoteMessageTap => arguments.onQuoteMessageTap;

  ///头像长按事件
  MediaAvatarLongPressCallback? get onMediaLongPressed =>
      arguments.onMediaLongPress;

  // ///
  // GlobalKey get messageBodyKey => arguments.messageBodyKey;

  ///
  DateTime get sendTime => arguments.message.sendTime;

  final _messageStateGlobalKey = GlobalKey();

  GlobalKey get messageStateGlobalKey => _messageStateGlobalKey;
}

class MessageWidgetState<T extends MessageWidget> extends State<T>
    implements IMessageWidgetState {
  ///
  final GlobalKey messageBodyGlobalKey = GlobalKey();

  ///
  MessageArguments get arguments => widget.arguments;

  ///
  bool isHover = false;

  ///
  @override
  bool isPlayed = false;

  @override
  bool isReaded = true;

  @override
  MessageStateEnum? messageState;

  @override
  void initState() {
    super.initState();
    messageState = widget.message.state;
  }

  ///
  @override
  List<MessageMenuButton> buildMessageMenus(MessageArguments arguments) => [];

  ///
  void _openMenuDialog() {
    var menus = buildMessageMenus.call(arguments);
    if (menus.isEmpty) {
      return;
    }
    Logger().d('_openMenuDialog');
    widget.arguments.messageDialogKey?.currentState
        ?.open(messageBodyGlobalKey, menus);
  }

  ///触发 LongPressed 事件
  void onMessageLongPressed() {
    _openMenuDialog();
    Utils.vibrateSuccess();
  }

  void navToMessageViewer() {
    var messageList = MessageListViewState.of(context)
        ?.messageList
        .where((x) =>
            [MessageTypeEnum.image, MessageTypeEnum.video].contains(x.type))
        .toList();
    if (messageList?.isEmpty ?? true) {
      Logger().w('_messageList:${messageList?.length}');
      return;
    }
    Logger().d('_messageList:${messageList?.length}');
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animatable, secondaryAnimation) =>
            MessageViewerPage(
          messages: messageList!,
          index: messageList.indexOf(widget.message),
          // image
        ),
      ),
    );
  }

  ///触发 Tap 事件
  void onMessageTap() {
    setIsPlayed(true);
    Logger().d('onMessageTap');
    ChatInputState? chatInputState =
        widget.arguments.chatInputKey?.state<ChatInputState>();
    chatInputState?.closeChatInput();
    // Utils.vibrateSuccess();
    widget.arguments.onMessageTap?.call();
  }

  ///
  @override
  void setMessageState(MessageStateEnum value) {
    // setState(() {
    //   messageState = value;
    // });
    widget.message.setMessageState(MessageStateEnum.success);
    widget.messageStateGlobalKey
        .state<MessageStateWidgetState>()
        ?.setMessageState(value);
  }

  ///
  @override
  void setIsPlayed(bool value) {
    Logger().w('未实现 setIsPlayed:$value');
    // setState(() {
    //   isPlayed = value;
    // });
  }

  ///
  @override
  void setIsReaded(bool value) {
    // setState(() {
    //   isReaded = value;
    // });
  }

  Widget bodyGestureDetector({required Widget child}) {
    return GestureDetector(
      key: messageBodyGlobalKey,
      // onTapDown: (details) {
      //   setState(() {
      //     Logger().i('onTapDown isHover');
      //     isHover = true;
      //   });
      // },
      // onTapUp: (details) {
      //   setState(() {
      //     isHover = false;
      //   });
      // },
      // onTapCancel: () {
      //   setState(() {
      //     isHover = false;
      //   });
      // },
      onTap: onMessageTap,
      onLongPress: onMessageLongPressed,
      child: child,
    );
  }

  ///
  @override
  Widget buildSendTime(BuildContext context) {
    if (!arguments.isShowSendTime) {
      return const SizedBox();
    }
    return MessageSendtimeWidget(
      key: ValueKey(widget.sendTime),
      isDisplay: widget.isSendTimeDisplay,
      sendTime: widget.sendTime,
    );
  }

  ///
  @override
  Widget buildMediaAvatarWidget(BuildContext context) {
    return MediaAvatar(
      meidaId: widget.message.sender,
      meidaType: widget.message.senderType,
      isDisplay: widget.isMediaAvatarDisplay,
      size: MessageArguments.mediaSize,
      onLongPressed: (p0, p1, p2) {
        widget.onMediaLongPressed?.call(p0, p1, widget.isSelf);
      },
    );
  }

  ///
  @override
  Widget buildMediaNameWidget(BuildContext context) {
    return MediaNameWidget(
      mediaId: widget.message.sender,
      mediaType: widget.message.senderType,
      isDisplay: widget.isMediaNameDisplay,
    );
  }

  ///
  @override
  Widget buildMessageStateWidget(BuildContext context) {
    return MessageStateWidget(
      key: widget.messageStateGlobalKey,
      isDisplay: widget.isSelf,
      // state: messageState,
      state: widget.message.state,
    );
  }

  @override
  Widget buildMessageContentWidget(BuildContext context) {
    // return const Text('data');
    return const Text('不支持');
  }

  @override
  Widget buildMessageBodyWidget(BuildContext context) {
    double width = 32;
    // return Text('data');
    return Column(
      // textDirection: textDirection,
      crossAxisAlignment:
          widget.isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: widget.isSelf ? width : 0,
                right: widget.isSelf ? 0 : width,
              ),
              child: buildMessageContentWidget(context),
            ),
            Positioned(
              left: widget.isSelf ? 0 : null,
              right: widget.isSelf ? null : 0,
              top: 0,
              bottom: 0,
              child: buildMessageStateWidget(context),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget buildQuoteMessageWidget(BuildContext context) {
    return MessagePreview(
      onClose: () {},
      onQuoteMessageTap: widget.onQuoteMessageTap,
      message: widget.quoteMessage,
    );
  }

  @override
  Widget buildSeparatedWdiget(BuildContext context) {
    // return const SizedBox(
    //   height: 0.5,
    //   child: Divider(
    //     height: 0.5,
    //   ),
    // );
    return const SizedBox();
  }

  @override
  Widget buildRollbackedWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(MessageArguments.marginAll),
      // height: 22,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(3),
        ),
        child: RichText(
          text: TextSpan(
              text: 'chen zhongpei',
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 0, 108, 18),
              ),
              children: [
                TextSpan(
                  text: '消息已经撤回',
                  style: TextStyle(
                    // letterSpacing: 5.0,
                    // wordSpacing: 5.0,
                    // fontSize: 12,
                    color: Colors.grey.shade500,
                    // decoration: TextDecoration.lineThrough),
                  ),
                )
              ]),
        ),
      ),
    );
  }

  @override
  Widget buildMessageBanner(BuildContext context) {
    return ChoiceContainer(
      isChecked: widget.arguments.isChecked,
      isChoiceMode: arguments.isChoiceMode,
      onChanged: (value) {
        widget.arguments.onMessageChanged?.call(value!);
      },
      margin: const EdgeInsets.all(MessageArguments.marginAll),
      size: MessageArguments.mediaSize,
      child: Row(
        textDirection: widget.isSelf ? TextDirection.rtl : TextDirection.ltr,
        // mainAxisAlignment: MainAxisAlignment.start,
        // verticalDirection: VerticalDirection.up,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMediaAvatarWidget(context),
          Expanded(
            child: Column(
              crossAxisAlignment: widget.isSelf
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                buildMediaNameWidget(context),
                buildMessageBodyWidget(context),
                buildQuoteMessageWidget(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildMessageScaffold(BuildContext context) {
    // Logger().d('${toString()} -buildMessageScaffold');
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      // verticalDirection: VerticalDirection.down,
      children: [
        // 发送时间
        buildSendTime(context),
        widget.message.isRollbacked
            ? buildRollbackedWidget(context)
            : buildMessageBanner(context),
        buildSeparatedWdiget(context),
      ],
    );
  }

  // ///
  // // @override
  // Widget buildWidget(BuildContext context) {
  //   // Logger().d('${toString()} -buildWidget');
  //   return Container(
  //     margin: const EdgeInsets.all(MessageArguments.marginAll),
  //     // decoration: BoxDecoration(
  //     //     color: const Color.fromARGB(255, 178, 178, 178),
  //     //     borderRadius: BorderRadius.circular(3.0)),
  //     child: Column(
  //       // mainAxisAlignment: MainAxisAlignment.start,
  //       // verticalDirection: VerticalDirection.down,
  //       children: [
  //         // 发送时间
  //         buildSendTime(context),
  //         Row(
  //           textDirection:
  //               widget.isSelf ? TextDirection.rtl : TextDirection.ltr,
  //           // mainAxisAlignment: MainAxisAlignment.start,
  //           // verticalDirection: VerticalDirection.up,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             buildMediaAvatarWidget(context),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: widget.isSelf
  //                     ? CrossAxisAlignment.end
  //                     : CrossAxisAlignment.start,
  //                 children: [
  //                   buildMediaNameWidget(context),
  //                   Row(
  //                     textDirection:
  //                         widget.isSelf ? TextDirection.rtl : TextDirection.ltr,
  //                     children: [
  //                       //====================================================要改的
  //                       buildMessageBodyWidget(context),
  //                       // GestureDetector(
  //                       //   key: widget.messageBodyKey,
  //                       //   onTap: widget.onMessageTap,
  //                       //   onLongPress: widget.onMessageLongPress,
  //                       //   child: widget.buildMessageBodyWidget(context),
  //                       // ),
  //                       buildMessageStateWidget(context),
  //                     ],
  //                   ),
  //                   buildQuoteMessageWidget(context),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         buildSeparatedWdiget(context),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // Logger().d('${toString()} -build');
    return buildMessageScaffold(context);
  }

  // MenuButton _buildMenuButton(
  //     MenuTypeEnum code, IconData iconData, String text) {
  //   return MenuButton(
  //     direction: Axis.vertical,
  //     color: Colors.white70,
  //     iconData: iconData,
  //     text: text,
  //     code: code,
  //     disabled: false,
  //     width: 40,
  //     // height: 60,
  //     onTap: (_) {
  //       Logger().d('menu tap:$code,disabled:${_.disabled}');
  //       widget.arguments.onMenuTap?.call(_);
  //       _closeMenuDialog();
  //     },
  //   );
  // }

  // ///
  // MenuButton copyButton() =>
  //     _buildMenuButton(MenuTypeEnum.copy, Icons.copy, '复制');

  // ///
  // MenuButton forwardButton() =>
  //     _buildMenuButton(MenuTypeEnum.forward, Icons.forward, '转发');

  // ///
  // MenuButton quoteButton() =>
  //     _buildMenuButton(MenuTypeEnum.quote, Icons.format_quote_sharp, '引用');

  // ///
  // MenuButton favoriteButton() =>
  //     _buildMenuButton(MenuTypeEnum.favorite, Icons.bookmark_add, '收藏');

  // ///
  // MenuButton soundPlayButton() => _buildMenuButton(
  //     MenuTypeEnum.soundPlay, Icons.play_circle_fill_sharp, '播放');

  // ///
  // MenuButton headPhonesButton() =>
  //     _buildMenuButton(MenuTypeEnum.headPhones, Icons.headphones, '听筒');

  // ///
  // MenuButton reminderButton() =>
  //     _buildMenuButton(MenuTypeEnum.reminder, Icons.notifications, '提醒');

  // ///
  // MenuButton rollbackButton() =>
  //     _buildMenuButton(MenuTypeEnum.rollback, Icons.u_turn_left_rounded, '撤回');

  // MenuButton choiceButton() => _buildMenuButton(
  //     MenuTypeEnum.multipleChoice, Icons.checklist_rtl_sharp, '多选');
}

abstract class IMessageWidgetState {
  ///
  late MessageStateEnum? messageState;

  ///
  late bool isReaded;

  ///
  late bool isPlayed;

  ///
  void setMessageState(MessageStateEnum messageState);

  ///
  void setIsReaded(bool isReaded);

  ///
  void setIsPlayed(bool isPlayed);

  ///
  List<MessageMenuButton> buildMessageMenus(MessageArguments arguments);

  ///发送时间
  Widget buildSendTime(BuildContext context);

  ///媒体头像
  Widget buildMediaAvatarWidget(BuildContext context);

  ///媒体名称
  Widget buildMediaNameWidget(BuildContext context);

  ///消息状态
  Widget buildMessageStateWidget(BuildContext context);

  ///消息主体
  Widget buildMessageBodyWidget(BuildContext context);

  ///消息内容
  Widget buildMessageContentWidget(BuildContext context);

  ///消息通栏
  Widget buildMessageBanner(BuildContext context);

  ///
  Widget buildRollbackedWidget(BuildContext context);

  ///引用消息
  Widget buildQuoteMessageWidget(BuildContext context);

  ///消息分隔部件
  Widget buildSeparatedWdiget(BuildContext context);

  /// 消息骨架
  Widget buildMessageScaffold(BuildContext context);
}

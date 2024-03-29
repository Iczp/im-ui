import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/src/providers/session_unit_provider.dart';
import 'package:im_ui/src/widgets/message_menu_buttons_all.dart';
import 'package:im_ui/src/sessions/session_title.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../apis/api.dart';
import '../models/message_arguments.dart';
import '../providers/max_log_id_provider.dart';
import '../providers/message_provider.dart';
import '../chat_input/input_function_buttons.dart';
import '../chat_input/chat_input.dart';
import '../widgets/dialog/media_menu_dialog.dart';
import '../menus/message_menu_dialog.dart';
import '../widgets/mask.dart';
import '../menus/menu_button.dart';
import '../messages/message_widget.dart';
import '../widgets/operation_menus.dart';
import '../messages/list_view/message_list_view.dart';
// import 'widget/notice_widget.dart';

/// 聊天页
class ChatingPage extends StatefulWidget {
  final int scrollMode;

  ///
  const ChatingPage({
    super.key,
    required this.media,
    required this.title,
    this.scrollMode = 0,
    required this.sessionUnitId,

    ///
    this.choiceMode,
    // this.choiceMode,
    this.choiceMaxCount,
    this.choiceMinCount,
  });

  final String sessionUnitId;

  ///
  final MediaInput media;

  ///标题
  final String title;

  ///选择模式
  final ChoiceModeEnum? choiceMode;

  ///
  final int? choiceMaxCount;

  ///
  final int? choiceMinCount;

  ///
  bool get isSignalMode => choiceMode == ChoiceModeEnum.single;

  @override
  createState() => _ChatingPageState();
}

class _ChatingPageState extends State<ChatingPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  ///
  var buildCount = 0;

  ///
  final String? title = "chating";

  ///
  String? _maskCaller;

  ///========================================
  final GlobalKey<MessageMenuDialogState> _messageDialogKey = GlobalKey();

  MessageMenuDialogState? get messageMenuDialogState =>
      _messageDialogKey.currentState;

  ///
  final GlobalKey<ChatInputState> _chatInputKey = GlobalKey();

  ///
  final GlobalKey<MessageListViewState> _listViewKey = GlobalKey();

  ///消息内容Key
  GlobalKey? _messageSourceKey;

  ///
  LayerLink? _messageLayerLink;

  ///
  final TextEditingController _messageTextEditingController =
      TextEditingController();

  ///
  final FocusNode _messageFocusNode = FocusNode();

  ///
  ChoiceModeEnum? _choiceMode;

  StreamSubscription? subscription;

  ///
  MessageProvider get messageProvider => context.read<MessageProvider>();

  ///
  MessageListViewState get messageListViewState => _listViewKey.currentState!;

  ///
  ChatInputState get chatInputState => _chatInputKey.currentState!;

  ///
  String get sessionUnitId => widget.sessionUnitId;

  ///
  @override
  void initState() {
    super.initState();
    // Logger().i('initState');

    _choiceMode = widget.choiceMode;
    // _isSoundInputDialogDisplay = false;

    //subscription
    ///
    // subscription = chatingStreamController.stream.listen((event) {
    //   Logger().d(event);
    // });
    WidgetsBinding.instance.addObserver(this);
    fetchData();
  }

  @override
  Future<void> dispose() async {
    ///

    subscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    Logger().w('chating page dispose');
    super.dispose();
  }

  void fetchData() {
    SessionUnitGetMessageList(
      id: sessionUnitId,
    ).submit().then((ret) {
      Logger().e(ret.totalCount);
      messageProvider.append(sessionUnitId, ret.items[0]);
      messageListViewState.setMessages(ret.items.reversed.toList());

      // messageListViewState.scrollToBottom();
      messageListViewState.setState(() {});
    });
  }

  ///
  Future<bool> _onWillPop() async {
    // setReaded();
    Logger().d('_onWillPop');

    // _messageListViewState.getItemInfo(0);

    if (chatInputState.isKeyboardVisible) {
      chatInputState.setKeyboardVisible(false);
      return false;
    }

    setReaded();

    // Logger().d(
    //     'scrollController maxScrollExtent:${_messageListViewState.scrollController.position.maxScrollExtent}');

    // context.read<ScrollProvider>().storageScroll(
    //     sessionUnitId,
    //     ScrollModel(
    //       maxScrollExtent:
    //           _messageListViewState.scrollController.position.maxScrollExtent,
    //       currentPixels: _messageListViewState.scrollController.position.pixels,
    //     ));
    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    Logger().w("lifeChanged $state");
  }

  ///
  Future setReaded() async {
    // var messages = MessageProvider.getMessages(sessionUnitId);
    var messages = messageListViewState.messageList;

    // var lastMessage = messages.lastOrNull((x) => x.id != null);

    var lastMessage = messages.where((x) => x.id != null).max((x) => x.autoId);

    if (lastMessage != null) {
      // context
      //     .read<ReadedRecordProvider>()
      //     .setReaded(sessionUnitId, lastMessage.autoId, lastMessage.globalKey);

      Logger().w('lastMessage:$lastMessage');
      SessionUnitProvider.instance.setReaded(
        id: sessionUnitId,
        messageId: lastMessage.id!,
        messageAutoId: lastMessage.autoId,
      );
    }

    Logger().w('setReaded messages.length:${messages.length}');
  }

  ///
  void setChoiceMode(ChoiceModeEnum? mode) {
    setState(() {
      _choiceMode = mode;
    });
  }

  @override
  bool get wantKeepAlive => true;

  ///
  MessageDto buildMessage<T extends MessageContent>(T content) {
    var messageList = messageListViewState.messageList;
    Logger().d('_messageList.length:${messageList.length}');
    var logId = MaxLogIdProvider.takeMaxLogId();
    return MessageDto(
      id: GlobalKey().toString(),
      autoId: logId,
      senderId: messageList.length % 2 == 0 ? 'zhongpei' : widget.media.mediaId,
      receiverId:
          messageList.length % 2 == 1 ? 'zhongpei' : widget.media.mediaId,
      // media: MediaTypeEnum.personal,
      content: content,
      creationTime: DateTime.now(),
      state: MessageStateEnum.pending,
      quoteMessage: chatInputState.quoteMessage,
      messageType: content.messageType,
      // rollbackTime: DateTime.now(),
    );
  }

  void onSend(MessageContent content) {
    sendMessage(
      buildMessage(content),
    );
  }

  ///发送消息
  void sendMessage(MessageDto message) {
    // Logger().d('_onSend:$message');

    // chatingStreamController.sink.add(['dddddddd']);
    messageListViewState.appendMessage(message);
    messageProvider.setMessages(
        sessionUnitId, messageListViewState.messageList);
    messageListViewState.scrollToNewLine();
    chatInputState.setQuoteMessage(null);

    api.sendMessage(sessionUnitId, message, () {}).then((value) {
      message.globalKey
          .state<MessageWidgetState>()
          ?.setMessageState(MessageStateEnum.success);
      messageProvider.updateMessage(sessionUnitId, message);
    }).catchError((err) {
      Logger().e(err);
    });
  }

  ///设置滚动物理学（false：禁止滚动）
  void setScrollable(bool isCanScroll) {}

  ///设置消息是否可以拖拽
  void setIsBuildMessageDrag(bool isBuildMessageDarg) {}

  /// closeMediaDialog
  void closeMediaDialog() {
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        setScrollable(true);
        _maskCaller = null;
      });
    });
  }

  /// 消息内容长按
  void onMessageLongPress(MessageArguments arguments) {
    Logger().i('onMessageLongPressed:${arguments.message}');

    var menus = <MessageMenuButton>[
      CopyMessageMenuButton(arguments),
      QuoteMessageMenuButton(arguments),
      SoundPlayMessageMenuButton(arguments),
      ForwardMessageMenuButton(arguments),
      FavoriteMessageMenuButton(arguments),
      ReminderMessageMenuButton(arguments),
      HeadphonesMessageMenuButton(arguments),
      ChoiceMessageMenuButton(arguments),
      RollbackMessageMenuButton(arguments),
      ShareMessageMenuButton(arguments),
    ];

    messageMenuDialogState?.open(arguments.message.contentGlobalKey, menus);
    // setState(() {
    //   // setScrollable(false);
    //   // _messageCurrentIndex = index;
    //   _messageSourceKey = message.globalKey;
    //   _maskCaller = MessageMenuDialog.caller;
    // });
  }

  /// 头像长按
  void onMediaLongPressed(
    GlobalKey globalKey,
    LayerLink layerLink,
    bool? isSelf,
  ) {
    setState(() {
      // setScrollable(false);
      _maskCaller = MediaMenuDialog.caller;
    });
  }

  // ///消息菜单处理
  // void onMessageMenuTap(MenuButton menuItem, int index) {
  //   Logger().d(menuItem.code);
  //   var message = _messageList[index];
  //   Logger().d('message:$message');

  //   switch (menuItem.code) {
  //     case MenuTypeEnum.quote:
  //       break;

  //     case MenuTypeEnum.copy:
  //       if (message.messageType == MessageTypeEnum.text) {
  //         var text = message.getContent<TextContentDto>().text;
  //         Logger().d('copy');
  //         Clipboard.setData(ClipboardData(text: text));
  //       }
  //       break;
  //     case MenuTypeEnum.rollback:
  //       Logger().i('is rollback:${message.isRollbacked}');
  //       Future.delayed(const Duration(milliseconds: 1000), () {
  //         // _messageList.removeAt(index);
  //         message.rollbackMessage();
  //         _messageList[index].rollbackMessage();
  //         Logger().i('rollbackTime:${message.rollbackTime}');
  //         Logger().i('is rollback:${message.isRollbacked}');
  //         setState(() {});
  //       });
  //       break;
  //     case MenuTypeEnum.multipleChoice:
  //       setChoiceMode(ChoiceModeEnum.multiple);
  //       break;
  //     default:
  //       break;
  //   }

  //   // closeMessageDialog();
  // }

  // /// closeMessageDialog
  // void closeMessageDialog() {
  //   Timer(const Duration(milliseconds: 100), () {
  //     setState(() {
  //       setScrollable(true);
  //       _maskCaller = null;
  //       _isMessageMenuDisplay = false;
  //       _activeMessage = null;
  //     });
  //   });
  // }

  /// 头像菜单处理
  void onMediaMenuDialogTap(MenuButton menuItem) {
    Logger().d(menuItem);
    closeMediaDialog();
  }

  ///
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Logger().d('message----build-$buildCount');

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        // fit: StackFit.expand,
        children: [
          // Positioned.fill(
          //   child: Container(
          //     constraints: const BoxConstraints.expand(),
          //     decoration: const BoxDecoration(
          //       image: DecorationImage(
          //         image: NetworkImage(
          //             "http://www.rctea.com/uploadFiles/product/300/320x320/8647b328.png"),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned.fill(
          //   child: Center(
          //     child: ClipRect(
          //       child: BackdropFilter(
          //         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          //         child: Container(
          //           constraints: const BoxConstraints.expand(),
          //           // width: 200,
          //           // height: 200,
          //           // color: Color.fromARGB(22, 245, 245, 245),
          //           child: const Center(
          //               // child: Text('ddd'),
          //               ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Scaffold(
            // 子组件若需要监听键盘高度，需设置为false
            resizeToAvoidBottomInset: false,
            // // 背景透明
            // backgroundColor: Colors.transparent,
            backgroundColor: const Color.fromARGB(255, 246, 246, 246),
            appBar: AppBar(
              // leading: ,
              elevation: 0,
              title: buildTitle(),
              actions: [
                IconButton(
                  onPressed: () {
                    Logger().d('more');
                    // Scaffold.of(context)
                    // Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //       builder: (context) => ChatSettingPage(
                    //         title: widget.title,
                    //       ),
                    //     ));
                  },
                  icon: badges.Badge(
                    showBadge: true,
                    // badgeColor: Colors.blue,
                    // shape: BadgeShape.square,
                    position: badges.BadgePosition.topEnd(top: 0, end: -5),
                    // borderRadius: BorderRadius.circular(5),
                    // badgeContent: const Text('3'),
                    child: const Icon(Icons.more_vert_rounded),
                  ),
                )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // const NoticeWidget(),
                buildMessageListView(),
                buildPageFooter(),
              ],
            ),
            // bottomNavigationBar: BottomAppBar(
            //   child: OverflowBar(
            //     overflowAlignment: OverflowBarAlignment.center,
            //     children: const [Text('data')],
            //   ),
            // ),
          ),
          Mask(
            // key: _maskKey,
            caller: _maskCaller,
            onClose: () {
              setState(() {
                setScrollable(true);
                _maskCaller = null;
              });
            },
          ),
          // MediaMenuDialog(
          //   isSelf: _mediaIsSelf,
          //   isDisplay: _isMediaMenuDisplay,
          //   layerLink: _mediaLayerLink,
          //   sourceKey: _mediaSourceKey,
          //   onMenuTap: onMediaMenuDialogTap,
          // ),
          MessageMenuDialog(
            key: _messageDialogKey,
            layerLink: _messageLayerLink,
            sourceKey: _messageSourceKey,
            // onMenuTap: onMessageMenuTap,
          ),
        ],
      ),
    );
  }

  Widget buildPageFooter() {
    return IndexedStack(
      index: _choiceMode == null ? 0 : 1,
      children: [buildChatInput(), buildOperation()],
    );
  }

  ///chat input
  Widget buildChatInput() {
    return ChatInput(
      key: _chatInputKey,
      functionPages: [
        [
          CameraFunctionButton(onSend: onSend),
          ImageFunctionButton(onSend: onSend),
          VideoFunctionButton(onSend: onSend),
          FileFunctionButton(onSend: onSend),
          LocationFunctionButton(onSend: onSend),
          ContactsFunctionButton(onSend: onSend),
          FavoritesFunctionButton(onSend: onSend),
          BallotFunctionButton(onSend: onSend),
        ],
        [
          MoreFunctionButton(onSend: onSend),
        ]
      ],
      media: widget.media,
      focusNode: _messageFocusNode,
      controller: _messageTextEditingController,
      onSoundInput: (isInputing) {
        Logger().d('ChatInput onSoundInput:$isInputing');
        setState(() {
          if (isInputing) {}
        });
      },
      onSend: onSend,
      onKeyboardChanged: (value) {
        // Logger().w('onKeyboardChanged:$value');
        messageListViewState.scrollReset(value);
      },
    );
  }

  ///
  Widget buildOperation() {
    // Logger().e('buildOperation');
    return OperationMenus(
      onMenuTap: (_) {
        Logger().d(_.code);
        switch (_.code) {
          case MenuTypeEnum.cancle:
            setChoiceMode(null);
            break;
          default:
        }
      },
    );
  }

  // ignore: unused_element
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('是否要删除'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('（按照一定的程序和技术要求进行活动） operate; manipulate'),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
                setChoiceMode(null);
              },
            ),
            ElevatedButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///
  buildMessageListView() {
    // return Selector<ChatingProvider, List<MessageDto>>(
    //   selector: (p0, p1) => p1.getSessionMessages(sessionUnitId),
    //   builder: (context, messages, child) {
    return MessageListView(
      media: widget.media,
      key: _listViewKey,
      messageDialogKey: _messageDialogKey,
      chatInputKey: _chatInputKey,
      onMessageLongPress: onMessageLongPress,
      scrollMode: widget.scrollMode,
      //   );
      // },
    );
  }

  Widget buildTitle() {
    return SessionTitle(
      sessionUnitId: sessionUnitId,
      title: widget.title,
      // subTitle: widget.title,
    );
  }
}

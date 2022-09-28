import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/im_ui.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../commons/utils.dart';
import '../../models/message_arguments.dart';
import '../../providers/keyboard_provider.dart';
import '../../providers/message_provider.dart';
import '../../providers/readed_record_provider.dart';
import '../../providers/users_provide.dart';
import '../../chat_input/chat_input.dart';
import '../../menus/message_menu_dialog.dart';
import '../message_resolver.dart';
import 'loading_widget.dart';
import 'reminder_positioned.dart';

class MessageListView extends StatefulWidget {
  ///消息长按
  final ValueChanged<MessageDto>? onMessageLongPress;

  ///
  final GlobalKey<MessageMenuDialogState>? messageDialogKey;

  /// _chatInputKey
  final GlobalKey<ChatInputState>? chatInputKey;

  ///
  final MediaInput media;

  ///
  final int scrollMode;

  ///
  const MessageListView({
    GlobalKey? key,
    this.onMessageLongPress,
    this.messageDialogKey,
    this.chatInputKey,
    required this.media,
    this.scrollMode = 0,
  }) : super(key: key);

  @override
  State<MessageListView> createState() => MessageListViewState();
}

class MessageListViewState extends State<MessageListView>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  ///
  MessageListViewState() {
    ///
  }

  ///消息列表
  ///
  late List<MessageDto> _messageList = <MessageDto>[];

  ///
  late bool _isReverse = true;

  ///
  final GlobalKey<LoadingWidgetState> _footerKey = GlobalKey();

  ///
  final GlobalKey<LoadingWidgetState> _headerKey = GlobalKey();

  ///
  final GlobalKey<ReminderPositionedState> _topReminderKey = GlobalKey();

  ///
  final GlobalKey<ReminderPositionedState> _bottomReminderKey = GlobalKey();

  ///
  bool _isUpPosting = false;

  ///
  bool _isDownPosting = false;

  ///
  double? maxReadedLogId;

  ///
  var buildCount = 0;

  ///
  final String? title = "chating";

  ///
  GlobalKey<ChatInputState>? get chatInputKey => widget.chatInputKey;

  /// 当前活跃的消息 index
  int? _activeMessageIndex;

  /// 滚动监听
  final ScrollController scrollController = ScrollController();

  ///是否可以拖拽
  bool _isBuildMessageDarg = true;

  ///滚动物理学
  ScrollPhysics? _physics =
      const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());

  ///
  ChoiceModeEnum? _choiceMode;

  ///
  late ReadedRecordModel? _readedLogId;

  ///
  MessageProvider get chatingProvider => context.read<MessageProvider>();

  ///
  String get sessionId => widget.media.sessionId;

  ///
  LoadingWidgetState? get headerLoadingWidgetState => _headerKey.currentState;

  ///
  LoadingWidgetState? get footerLoadingWidgetState => _footerKey.currentState;

  ///
  ReminderPositionedState? get bottomReminder =>
      _bottomReminderKey.currentState;

  ///
  ReminderPositionedState? get topReminder => _topReminderKey.currentState;

  ///
  bool get reverse => _isReverse;

  ///
  double get maxScrollExtent => scrollController.position.maxScrollExtent;

  ///
  double get pixels => scrollController.position.pixels;

  ///
  List<MessageDto> get messageList =>
      _isReverse ? _messageList.reversed.toList() : _messageList;

  ///
  @override
  bool get wantKeepAlive => true;

  ///
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _readedLogId = context.read<ReadedRecordProvider>().getReaded(sessionId);
    // _readedLogId = 29;
    // Logger().w('_readedLogId:$_readedLogId');
    // Logger().w('_messageList:${_messageList.length}');

    // if (_messageList.length > 10) {
    //   _isReverse = true;
    // }

    // int takeCount = 15;

    /// 滚动定位 方式1
    _messageList = MessageProvider.getMessages(
      sessionId,
      // reversed: _isReverse,
    );
    if (_isReverse) {
      _messageList = _messageList.reversed.toList();
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   var allMessages = ChatingProvider.getMessages(sessionId);
    //   if (allMessages.length > takeCount) {
    //     _messageList = allMessages;
    //     setState(() {});
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       scrollController.position
    //           .moveTo(scrollController.position.maxScrollExtent);
    //     });
    //   }
    // });

    /// addListener
    scrollController.addListener(_scrollHander);

    ///
    if (_isReverse) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var maxScrollExtent = scrollController.position.maxScrollExtent;
        // var pixels = scrollController.position.pixels;
        // Logger().w('maxScrollExtent:$maxScrollExtent,pixels:$pixels');
        // Logger().w(
        //     'viewportDimension:${scrollController.position.viewportDimension}');
        if (maxScrollExtent > 0) {
          return;
        }
        Future.delayed(const Duration(milliseconds: 0), () {
          _isReverse = false;
          _messageList = _messageList.reversed.toList();
          setState(() {});
        });
      });
    }

    ///
    WidgetsBinding.instance.addPostFrameCallback((_) {
      topReminder?.show('共有 ${_messageList.length} 消息');
    });
  }

  ///
  @override
  void didUpdateWidget(covariant MessageListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    Logger().e('didUpdateWidget');
  }

  ///
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Logger().e('didChangeDependencies');
  }

  ///
  @override
  void dispose() {
    scrollController.dispose();
    _messageList = <MessageDto>[];
    WidgetsBinding.instance.removeObserver(this); //销毁
    super.dispose();
  }

  ///
  static MessageListViewState? of(BuildContext context) {
    final MessageListViewState? result =
        context.findAncestorStateOfType<MessageListViewState>();
    if (result == null) {
      Logger().w('MessageListViewState is null');
    }
    return result;
  }

  ///_scrollHander
  void _scrollHander() {
    var pixels = scrollController.position.pixels;
    if (pixels < scrollController.position.minScrollExtent - 50) {
      // Logger().d(':up:$pixels');
      _headerHander();
    } else if (pixels > scrollController.position.maxScrollExtent + 50) {
      _footerHander();
      // Logger().d(':down:${pixels - scrollController.position.maxScrollExtent}');
    }
  }

  ///
  List<MessageDto> generateMessage(int count) => List.generate(count, (index) {
        double logId = (_messageList.length + 1 + index).toDouble();
        return MessageDto(
          id: GlobalKey().toString(),
          logId: logId,
          sender: index % 2 == 0 ? 'zhongpei' : widget.media.mediaId,
          receiver: index % 2 == 1 ? 'zhongpei' : widget.media.mediaId,
          media: MediaTypeEnum.personal,
          content: TextContentDto(text: 'logId:$logId'),
          sendTime: DateTime.now(),
          state: MessageStateEnum.success,
          type: MessageTypeEnum.text,
          // rollbackTime: DateTime.now(),
        );
      });

  ///  header1
  void sm0() {
    _messageList = _messageList.reversed.toList();
    var msgs = generateMessage(1);
    _messageList.addAll(msgs);

    bottomReminder?.show('${msgs.length} 条新消息 sm0_isReverse:$_isReverse');
    _isReverse = false;
    scrollController.position.moveTo(maxScrollExtent);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isUpPosting = false;
      var offset = _isReverse
          ? maxScrollExtent - scrollController.position.viewportDimension
          : maxScrollExtent;
      headerLoadingWidgetState?.hide();
      scrollController.animateTo(
        offset,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  /// header2
  void sm1() {
    _messageList.insertAll(0, generateMessage(1));
    setState(() {});
    scrollController.position.moveTo(headerLoadingWidgetState!.height);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isUpPosting = false;
      headerLoadingWidgetState?.hide();
      await scrollController.animateTo(
        scrollController.position.minScrollExtent,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  /// 头部:新消息处理
  void _headerHander() async {
    // Logger().w('_headerHander _isUpPosting:$_isUpPosting');
    if (_isUpPosting) {
      return;
    }
    headerLoadingWidgetState?.show();
    Logger().w('_headerHander _isReverse:$_isReverse');
    _isUpPosting = true;
    await Future.delayed(const Duration(milliseconds: 1200));
    if (_isReverse) {
      sm0();
      // sm1();

      ///
    } else {
      _messageList = _messageList.reversed.toList();
      var msgs = generateMessage(10);
      _messageList.addAll(msgs);
      _isReverse = true;
      bottomReminder?.show('${msgs.length} 条新消息 _isReverse:$_isReverse');
      Logger().d(
          'maxScrollExtent:${scrollController.position.maxScrollExtent},$maxScrollExtent');
      Logger().d('pixels:${scrollController.position.pixels},$pixels');
      scrollController.position.moveTo(
        maxScrollExtent - 22,
        // curve: Curves.easeIn,
        // duration: const Duration(milliseconds: 300),
      );

      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isUpPosting = false;
        headerLoadingWidgetState?.hide();
      });
    }
  }

  /// 底部:历史消息处理
  Future<void> _footerHander() async {
    if (_isDownPosting) {
      return;
    }
    // setState(() {});
    Logger().w('_footerHander:$_isDownPosting');
    footerLoadingWidgetState?.show();
    _isDownPosting = true;
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!_isReverse) {
      // _messageList = _messageList.reversed.toList();
      var msgs = generateMessage(Random().nextInt(3) + 1);
      _messageList.addAll(msgs);
      // _isReverse = false;
      scrollController.position.moveTo(maxScrollExtent);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        var offset = _isReverse
            ? maxScrollExtent - scrollController.position.viewportDimension
            : maxScrollExtent;
        await scrollController.animateTo(
          offset,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 300),
        );
        bottomReminder
            ?.show('${msgs.length} 条新消息 footer_isReverse:$_isReverse');
      });

      ///
    } else {
      _messageList.addAll(generateMessage(10));
    }

    _isDownPosting = false;

    setState(() {
      footerLoadingWidgetState?.hide();
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Logger().d(
    //       'addPostFrameCallback maxScrollExtent:${scrollController.position.maxScrollExtent},$maxScrollExtent');
    //   Logger().d(
    //       'addPostFrameCallback pixels:${scrollController.position.pixels},$pixels');
    // });
  }

  ///
  void setChoiceMode(ChoiceModeEnum? mode) {
    setState(() {
      _choiceMode = mode;
    });
  }

  ///发送消息
  void appendMessage(MessageDto message) {
    Logger().d('sendMessage _isReverse:$_isReverse');
    if (_isReverse) {
      _messageList.insert(0, message);
    } else {
      _messageList.add(message);
    }

    setState(() {});
  }

  void setMessages(List<MessageDto> messages) {
    if (_isReverse) {
      _messageList = messages.reversed.toList();
    } else {
      _messageList = messages;
    }
    setState(() {});
  }

  ///
  void scrollToNewLine({int animate = 300}) {
    if (_isReverse) {
      scrollToTop(animate: animate);
    } else {
      scrollToBottom(animate: animate);
    }
  }

  ///
  void scrollReset(bool isKeyboardOpend) {
    if (_isReverse) {
      return;
    }
    var dir = isKeyboardOpend && !_isReverse ? 1 : -1;

    var pixels = scrollController.position.pixels;
    var keyboardHeight = context.read<KeyboardProvider>().keyboardHeight;

    if (_isReverse && isKeyboardOpend) {
      scrollController.position.moveTo(pixels + keyboardHeight);
    }
    var newPixels = pixels + keyboardHeight * dir;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: _isReverse ? 0 : 150));
      // if (scrollController.position.maxScrollExtent - newPixels < 80) {
      //   newPixels = scrollController.position.maxScrollExtent;
      // }
      await scrollController.position.moveTo(
        newPixels,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.ease,
      );
    });

    Logger().w('scrollReset pixels:$pixels,$newPixels');
  }

  ///
  void scrollToBottom({int animate = 300}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollTo(scrollController.position.maxScrollExtent, animate: animate);
    });
  }

  ///
  void scrollTo(double pixels, {int animate = 300, bool isNextTick = true}) {
    Logger().w('scrollTo addPostFrameCallback:scrollToBottom');
    if (animate == 0) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      return;
    }
    scrollController.animateTo(
      pixels,
      curve: Curves.ease,
      duration: Duration(milliseconds: animate),
    );
  }

  // void getItemInfo(int index) {
  //   // var message = _messageList[index];

  //   for (var message in _messageList) {
  //     Logger().d(
  //         'message${message.globalKey}: ${message.globalKey.currentContext}');
  //   }

  //   // RenderBox renderBox =
  //   //     message.globalKey.currentContext!.findRenderObject() as RenderBox;
  //   // final offset = renderBox.localToGlobal(const Offset(0, 0));
  //   // debugPrint("----------positions of red:$offset");
  //   // final size = renderBox.size;
  //   // debugPrint("----------size of red:$size");
  // }

  ///
  void scrollToTop({int animate = 300}) {
    Logger().d('message:${scrollController.position.hasPixels}');
    Logger().d('message:${scrollController.offset}');
    // Logger().d('message:${scrollController.position.setPixels(0)}');

    var maxScrollExtent = scrollController.position.maxScrollExtent;
    Logger().d('maxScrollExtent:$maxScrollExtent');

    Logger().d(
        'pixels:${scrollController.position.pixels},${scrollController.position.minScrollExtent}');
    if (scrollController.position.pixels ==
        scrollController.position.minScrollExtent) {
      scrollController.position.moveTo(48);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollTo(scrollController.position.minScrollExtent, animate: animate);
    });
  }

  ///设置引用消息
  void setQuoteMessage(MessageDto? quoteMessage) {
    chatInputKey?.currentState!.setQuoteMessage(quoteMessage);
  }

  ///设置滚动物理学（false：禁止滚动）
  void setScrollable(bool isCanScroll) {
    _physics = isCanScroll
        ? const BouncingScrollPhysics()
        : const NeverScrollableScrollPhysics();
  }

  ///设置消息是否可以拖拽
  void setIsBuildMessageDrag(bool isBuildMessageDarg) {
    _isBuildMessageDarg = isBuildMessageDarg;
  }

  /// 是否显示发送时间
  bool isShowSendTime(int index) {
    var firstIndex = _isReverse ? _messageList.length - 1 : 0;
    var previousIndex = _isReverse ? index + 1 : index - 1;
    if (index == firstIndex) {
      return true;
    }
    var diff = _messageList[index]
        .sendTime
        .difference(_messageList[previousIndex].sendTime);

    return diff.inMinutes >= 3;
  }

  ///
  Widget buildListView() {
    var currentUser = context.read<UsersProvide>().currentUser;

    return GestureDetector(
      onTap: () {
        Logger().d('GestureDetector: onTap');
        chatInputKey?.state<ChatInputState>()?.closeChatInput();
      },
      child: ReorderableListView.builder(
        key: PageStorageKey(sessionId),
        shrinkWrap: false,
        primary: false,
        physics: _physics,
        reverse: _isReverse,

        ///设置消息是否可以拖拽
        buildDefaultDragHandles: false,
        // controller: _scrollController,
        scrollController: scrollController,
        itemCount: _messageList.length,
        itemBuilder: (BuildContext context, int index) {
          var message = _messageList[index]..setLoginUserId(currentUser?.id);

          ///
          var shouldShowNew =
              index != (_isReverse ? 0 : messageList.length - 1) &&
                  (_readedLogId?.globalKey == message.globalKey ||
                      _readedLogId?.logId == message.logId);
          return MessageResolver(
            key: ValueKey(message.globalKey.toString()),
            arguments: MessageArguments(
              // messageBodyKey: messageBodyKey,
              media: widget.media,
              listViewKey: widget.key,
              chatInputKey: widget.chatInputKey,
              choiceMode: _choiceMode,
              // isChecked: selectorController.isChecked(_messageList[index]),
              message: message,
              isShowSendTime: isShowSendTime(index),
              messageDialogKey: widget.messageDialogKey,
              isSoundPlay: index == _activeMessageIndex,
              // onMediaLongPress: onMediaLongPressed,
              // onMessageLongPress: (messageBodyKey) =>
              //     widget.onMessageLongPress?.call(message),
              // onMessageTap: () => onMessageTap(index),
              // onMenuTap: (_) => onMessageMenuTap(_, index),
              // onMessageChanged: (_) => onMessageChanged(_, index),
            ),
            footer:
                shouldShowNew ? const TextDivider('以下是新消息') : const SizedBox(),
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var item = _messageList.removeAt(oldIndex);
            _messageList.insert(newIndex, item);
          });
        },
        onReorderStart: (index) {
          // Logger().d('onReorderStart:$index');
          Utils.vibrateSuccess();
        },
        onReorderEnd: (index) {
          // Logger().d('onReorderEnd:$index');
        },
        header: LoadingWidget(key: _headerKey, color: Colors.red),
        footer: LoadingWidget(key: _footerKey, color: Colors.green),
      ),
    );
  }

  ///
  Widget buildTopReminder() {
    return ReminderPositioned(
      key: _topReminderKey,
      top: 8,
    );
  }

  ///
  Widget buildBottomReminder() {
    return ReminderPositioned(
      key: _bottomReminderKey,
      bottom: 8,
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Expanded(
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          buildListView(),
          buildTopReminder(),
          buildBottomReminder(),
        ],
      ),
    );
  }
}

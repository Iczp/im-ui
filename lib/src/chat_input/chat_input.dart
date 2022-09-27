import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:im_core/im_core.dart';

import 'package:logger/logger.dart';

import '../models/sound_inputing_model.dart';
import '../widgets/message_template/message_preview.dart';
import 'input_bar.dart';
import 'input_function_buttons.dart';
import 'inputing_container.dart';
import 'keyboard_container.dart';

class ChatInput extends StatefulWidget {
  ///
  const ChatInput({
    Key? key,
    required this.media,
    required this.controller,
    required this.focusNode,
    required this.functionPages,
    this.inputMode = InputModeEnum.keyboard,
    this.onSoundInput,
    this.onSlideChanged,
    this.onSoundInputing,
    // this.children,
    this.onSend,
    this.onKeyboardChanged,
    this.onInputTypeChanged,
  }) : super(key: key);

  ///
  final MediaInput media;
  // ///前置部件
  // final List<Widget>? children;

  ///TextEditingController
  final TextEditingController controller;

  ///FocusNode
  final FocusNode focusNode;

  /// 输入方式
  final InputModeEnum inputMode;

  ///发送
  final ValueChanged<MessageContent>? onSend;

  ///语音输入
  final ValueChanged<bool>? onSoundInput;

  ///语音输入变更
  final ValueChanged<bool>? onSlideChanged;

  ///
  final SoundInputingCallback? onSoundInputing;

  ///
  final ValueChanged<bool>? onKeyboardChanged;

  ///
  final ValueChanged<InputType>? onInputTypeChanged;

  ///
  final List<List<FunctionButton>> functionPages;

  @override
  State<ChatInput> createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  ///
  MessageDto? get quoteMessage => _quoteMessage;

  ///按钮是否或用
  bool _isSendBtnEnabled = false;

  ///
  MessageDto? _quoteMessage;

  ///
  final GlobalKey<KeyboardContainerState> _keyboardContainerKey = GlobalKey();

  ///
  final GlobalKey<InputModeContainerState> _inputModeKey = GlobalKey();

  ///
  late final FocusNode _focusNode = widget.focusNode;

  ///
  late final TextEditingController _textController = widget.controller;

  @override
  void didChangeDependencies() {
    // Logger().i('_focusNode:${_focusNode.hasFocus},${_focusNode.hasPrimaryFocus}');
    super.didChangeDependencies();
  }

  @override
  void initState() {
// _textEditingController.selection.
    //
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool get isKeyboardVisible =>
      _keyboardContainerKey.currentState?.visible ?? false;

  bool get isKeyboardOpened =>
      _keyboardContainerKey.currentState?.isOpend ?? false;

  InputType get inputType => _keyboardContainerKey.currentState!.inputType;

  ///
  void setKeyboardInputType(InputType inputType) {
    _keyboardContainerKey.currentState?.setInputType(inputType);
  }

  void setInputMode(InputModeEnum inputMode) {
    // inputModeButton

    _inputModeKey.currentState?.setInputMode(inputMode);
  }

  void setReadOnly(bool readOnly) {
    var state = _inputModeKey.currentState?.textInputKey.currentState;
    //
    if (state == null) {
      Logger().w('setReadOnly state:$state');
    }
    state?.setReadOnly(readOnly);
  }

  ///
  void setKeyboardVisible(bool visible) {
    _keyboardContainerKey.currentState?.setVisible(visible);
  }

  ///
  void setQuoteMessage(MessageDto? quoteMessage) {
    if (_quoteMessage == quoteMessage) {
      return;
    }
    setState(() {
      _quoteMessage = quoteMessage;
    });
  }

  ///设置发送按钮
  void _setSendBtnEnabled(bool enabled) {
    if (_isSendBtnEnabled != enabled) {
      setState(() {
        _isSendBtnEnabled = enabled;
      });
    }
  }

  /// 关闭输入框
  void closeChatInput() {
    setReadOnly(true);
    setKeyboardVisible(false);
    _hideKeyboardForce();
  }

  void _hideKeyboardForce() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    // FocusScope.of(context).requestFocus(FocusNode());
  }

  void showKeyboardForce() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  ///
  void _onFacePressed() {
    setInputMode(InputModeEnum.keyboard);
    if (isKeyboardOpened || inputType != InputType.face) {
      setKeyboardVisible(true);
      _hideKeyboardForce();
    } else {
      // FocusScope.of(context).requestFocus(FocusNode());
      if (_focusNode.hasFocus) {
        setKeyboardVisible(!isKeyboardVisible);
      } else {
        _focusNode.requestFocus();
        setKeyboardVisible(true);
      }
    }
    setKeyboardInputType(InputType.face);
  }

  ///
  void _onFunctionPressed() {
    setInputMode(InputModeEnum.keyboard);
    if (isKeyboardOpened || inputType != InputType.function) {
      setKeyboardInputType(InputType.function);
      setKeyboardVisible(true);
      _hideKeyboardForce();
    } else {
      setKeyboardInputType(
          isKeyboardVisible ? InputType.none : InputType.function);
      setKeyboardVisible(!isKeyboardVisible);
    }
  }

  ///
  void _onInputModeChanged(InputModeEnum inputMode) {
    Logger().d('inputMode:$inputMode');
    setInputMode(inputMode);
    setKeyboardInputType(InputType.none);
    setReadOnly(false);
    if (inputMode == InputModeEnum.keyboard) {
      setKeyboardVisible(true);

      // if (!_focusNode.hasPrimaryFocus) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Logger().d('_focusNode hasPrimaryFocus:${_focusNode.hasPrimaryFocus}');
        Logger().d('_focusNode.requestFocus():hasFocus:${_focusNode.hasFocus}');

        ///------------rebuild 后  state 可能为null
        setReadOnly(false);
        // showKeyboardForce();
        FocusScope.of(context).requestFocus(_focusNode);
        _focusNode.requestFocus();
      });
      // }
    } else {
      _hideKeyboardForce();
      setKeyboardVisible(false);
    }
  }

  ///
  static ChatInputState? of(BuildContext context) {
    final ChatInputState? result =
        context.findAncestorStateOfType<ChatInputState>();
    if (result == null) {
      Logger().w('ChatInputState is null');
    }
    return result;
  }

  ///
  Widget _header() {
    // if (widget.children == null) {
    //   return const SizedBox();
    // }

    if (_quoteMessage == null) {
      return const SizedBox();
    }
    return Wrap(
      children: [
        _quoteMessage != null
            ? MessagePreview(
                isDisplayClose: true,
                message: _quoteMessage,
                onClose: () {
                  setQuoteMessage(null);
                },
              )
            : const SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // messageTextEditingController

    return Material(
      child: Container(
        // padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        decoration: BoxDecoration(
          border: const Border(
            top: BorderSide(
                color: Colors.black38, width: 0.3, style: BorderStyle.solid),
          ),
          color: Colors.grey.shade200,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            InputBar(
              inputModeKey: _inputModeKey,
              controller: _textController,
              focusNode: _focusNode,
              inputMode: widget.inputMode,
              onInputModeChanged: _onInputModeChanged,
              onFacePressed: _onFacePressed,
              onFunctionPressed: _onFunctionPressed,
              onSendPressed: (value) {
                Logger().d(_textController.text);
                if (_textController.text.isEmpty) {
                  return;
                }
                widget.onSend?.call(TextContentDto(text: _textController.text));
                _textController.text = "";
                _setSendBtnEnabled(false);
              },
              onSoundInputed: (_) {
                widget.onSend?.call(SoundContentDto(
                  path: _.filePath,
                  time: _.duration,
                ));
              },
            ),
            KeyboardContainer(
              inputModeKey: _inputModeKey,
              key: _keyboardContainerKey,
              controller: _textController,
              onSend: widget.onSend,
              onInputTypeChanged: widget.onInputTypeChanged,
              onKeyboardChanged: widget.onKeyboardChanged,
              functionPages: widget.functionPages,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/src/widgets/chat-input/send_btn.dart';

import '../../models/sound_inputed_model.dart';
import '../../models/sound_inputing_model.dart';
import 'icon_btn.dart';
import 'input_bar_button/face_input_button.dart';
import 'input_bar_button/function_input_button.dart';
import 'input_mode_button.dart';
import 'inputing_container.dart';

class InputBar extends StatefulWidget {
  ///
  final GlobalKey inputModeKey;

  ///TextEditingController
  final TextEditingController controller;

  ///FocusNode
  final FocusNode focusNode;

  /// 输入方式
  final InputModeEnum inputMode;

  ///发送
  final ValueChanged<String>? onTextSend;

  ///语音输入
  final ValueChanged<bool>? onSoundInput;

  ///语音输入变更
  final ValueChanged<bool>? onSlideChanged;

  ///
  final SoundInputingCallback? onSoundInputing;

  ///
  final SoundSuccessCallback? onSoundInputed;

  ///
  final VoidCallback? onFunctionPressed;

  ///
  final VoidCallback? onFacePressed;

  ///
  final ValueChanged<InputModeEnum>? onInputModeChanged;

  ///
  final ValueChanged<String>? onTextInputChanged;

  ///
  final ValueChanged<String>? onSendPressed;

  ///
  const InputBar({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.inputMode,
    required this.inputModeKey,
    this.onTextSend,
    this.onSoundInput,
    this.onSlideChanged,
    this.onSoundInputing,
    this.onSoundInputed,
    this.onFunctionPressed,
    this.onFacePressed,
    this.onInputModeChanged,
    this.onTextInputChanged,
    this.onSendPressed,
  }) : super(key: key);

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        // margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(5),
        constraints: const BoxConstraints(
          // minHeight: 46.0,
          maxHeight: 100.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconBtn(
              iconData: Icons.menu_open,
              onPressed: () {
                // _hideKeyboard();
              },
            ),
            InputModeButton(
              inputMode: widget.inputMode,
              onChanged: widget.onInputModeChanged,
            ),
            // const SoundInput(),
            Expanded(
              child: InputModeContainer(
                key: widget.inputModeKey,
                inputMode: widget.inputMode,
                onChanged: widget.onTextInputChanged,
                controller: widget.controller,
                focusNode: widget.focusNode,
                // onSoundInput: widget.onSoundInput,
                onSlideChanged: widget.onSlideChanged,
                onSoundInputing: widget.onSoundInputing,
                onSuccess: widget.onSoundInputed,
              ),
            ),

            FaceInputButton(
              onPressed: widget.onFacePressed,
            ),
            FunctionInputButton(
              onPressed: widget.onFunctionPressed,
            ),
            SendContainer(
              // isDisplay: _inputMode != InputModeEnum.keyboard ||
              //     !_isSendBtnEnabled,
              isDisabled: true,
              onPressed: () {
                widget.onSendPressed?.call(widget.controller.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}

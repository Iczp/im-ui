import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';

import '../../models/sound_inputed_model.dart';
import '../../models/sound_inputing_model.dart';
import 'sound_input_container.dart';
import 'text_input_container.dart';

class InputModeContainer extends StatefulWidget {
  ///
  final TextEditingController? controller;

  ///
  final FocusNode? focusNode;

  ///
  final InputModeEnum inputMode;

  ///
  final ValueChanged<String>? onChanged;

  ///按钮滑动事件
  final ValueChanged<bool>? onSlideChanged;

  ///订阅事件间隔(录音分贝变化)
  final double? subscriptionDuration;

  ///录音分贝变化
  final SoundInputingCallback? onSoundInputing;

  ///成功
  final SoundSuccessCallback? onSuccess;

  ///
  const InputModeContainer({
    Key? key,
    this.controller,
    this.focusNode,
    this.onSlideChanged,
    this.subscriptionDuration,
    this.onSoundInputing,
    this.onSuccess,
    this.onChanged,
    required this.inputMode,
  }) : super(key: key);

  @override
  State<InputModeContainer> createState() => InputModeContainerState();
}

class InputModeContainerState extends State<InputModeContainer> {
  ///
  InputModeEnum _inputMode = InputModeEnum.keyboard;

  ///
  InputModeEnum get inputMode => _inputMode;

  ///
  GlobalKey<TextInputContainerState> textInputKey = GlobalKey();

  ///
  void setInputMode(InputModeEnum inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  @override
  void initState() {
    _inputMode = widget.inputMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: _inputMode == InputModeEnum.keyboard,
          child: TextInputContainer(
            key: textInputKey,
            inputMode: _inputMode,
            onChanged: (val) {
              // logger.d('onChanged:$val');
              // _setSendBtnEnabled(val.isNotEmpty);
            },
            controller: widget.controller,
            focusNode: widget.focusNode,
          ),
        ),
        Visibility(
          visible: _inputMode == InputModeEnum.sound,
          child: SoundInputContainer(
            // onSoundInput: widget.onSoundInput,
            onSlideChanged: widget.onSlideChanged,
            onSoundInputing: widget.onSoundInputing,
            onSuccess: widget.onSuccess,
          ),
        )
      ],
    );
  }
}

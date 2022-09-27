import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';

import 'icon_btn.dart';

typedef InputModeEnumCallback = void Function(InputModeEnum);

class InputModeButton extends StatefulWidget {
  ///
  final InputModeEnumCallback? onChanged;

  ///
  final InputModeEnum inputMode;

  ///
  const InputModeButton({
    super.key,
    this.inputMode = InputModeEnum.keyboard,
    this.onChanged,
  });

  ///
  @override
  State<InputModeButton> createState() => InputModeButtonState();
}

class InputModeButtonState extends State<InputModeButton> {
  bool isSoundInput = false;

  @override
  void initState() {
    super.initState();
    isSoundInput = widget.inputMode == InputModeEnum.sound;
  }

  void _onPressed() {
    setState(() {
      isSoundInput = !isSoundInput;
      // log('isSoundInput:$isSoundInput');
    });

    widget.onChanged
        ?.call(isSoundInput ? InputModeEnum.sound : InputModeEnum.keyboard);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        // SlideTransition
        return ScaleTransition(scale: animation, child: child);
      },
      child: IconBtn(
        key: ValueKey<bool>(isSoundInput),
        iconData: !isSoundInput ? Icons.volume_up_sharp : Icons.keyboard,
        onPressed: _onPressed,
      ),
    );
  }
}

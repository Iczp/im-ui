import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:im_core/im_core.dart';

import 'input_face_container.dart';
import 'input_function_button/function_button.dart';
import 'input_function_container.dart';
import 'keyboard_sized_box.dart';

///
enum InputType { none, function, face }

class KeyboardContainer extends StatefulWidget {
  ///
  final GlobalKey inputModeKey;

  ///发送
  final ValueChanged<MessageContent>? onSend;

  ///
  final TextEditingController? controller;

  ///
  final InputType inputType;

  ///
  final bool visible;

  ///
  final List<List<FunctionButton>> functionPages;

  ///
  final ValueChanged<bool>? onKeyboardChanged;

  ///
  final ValueChanged<InputType>? onInputTypeChanged;

  ///
  const KeyboardContainer({
    required Key key,
    required this.functionPages,
    this.inputType = InputType.none,
    this.controller,
    this.onSend,
    required this.inputModeKey,
    this.visible = false,
    this.onKeyboardChanged,
    this.onInputTypeChanged,
  }) : super(key: key);

  @override
  State<KeyboardContainer> createState() => KeyboardContainerState();
}

class KeyboardContainerState extends State<KeyboardContainer> {
  ///
  InputType _inputType = InputType.none;

  ///
  late StreamSubscription<bool> keyboardSubscription;

  ///
  late bool _visible = widget.visible;

  bool get visible => _visible;

  ///
  bool _isOpened = true;

  ///
  bool get isOpend => _isOpened;

  ///
  InputType get inputType => _inputType;

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    // Logger().d('Keyboard query: ${keyboardVisibilityController.isVisible}');
    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      _isOpened = visible;
      // Logger().d('Keyboard visible: $visible');

      if (visible) {
        setVisible(true);
      }

      if (!visible && _inputType == InputType.none) {
        setVisible(false);
        return;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  ///
  void setVisible(bool value) {
    if (_visible == value) {
      return;
    }
    setState(() {
      _visible = value;
      widget.onKeyboardChanged?.call(_visible);
    });
  }

  ///
  void setInputType(InputType type) {
    if (_inputType == type) {
      return;
    }
    setState(() {
      _inputType = type;
      widget.onInputTypeChanged?.call(_inputType);
    });
  }

  ///
  Widget _positionedVisibility({required bool visible, required Widget child}) {
    return Visibility(
        visible: visible,
        // maintainState: true,
        // maintainSize: true,
        child: Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: child,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            const KeyboardSizedBox(),
            _positionedDivider(),
            _positionedVisibility(
              visible: _inputType == InputType.face,
              child: InputFaceContainer(
                controller: widget.controller,
              ),
            ),
            _positionedVisibility(
              visible: _inputType == InputType.function,
              child: InputFunctionContainer(
                pages: widget.functionPages,
              ),
            )
          ],
        ),
      ),
    );
  }
}

///
Widget _positionedDivider() {
  return const Positioned(
    left: 0,
    right: 0,
    top: 0,
    child: Divider(
      height: 0.5,
      color: Colors.black12,
    ),
  );
}

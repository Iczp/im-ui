import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

import '../../providers/keyboard_provider.dart';

class KeyboardSizedBox extends StatefulWidget {
  ///
  final ValueChanged<bool>? onChange;

  ///
  final Widget? child;

  ///
  const KeyboardSizedBox({
    Key? key,
    this.onChange,
    this.child,
  }) : super(key: key);

  ///
  @override
  State<KeyboardSizedBox> createState() => _KeyboardSizedBoxState();
}

class _KeyboardSizedBoxState extends State<KeyboardSizedBox> {
  bool _isVisible = false;

  late StreamSubscription<bool> keyboardSubscription;
  // double _keyboardHeight = 300;
  // int microsecond = 0;

  void updateKeyboardHeight(v) {
    // var nextMicrosecond = DateTime.now().microsecondsSinceEpoch;
    // var ddd = (nextMicrosecond - microsecond) / 10000;
    // microsecond = nextMicrosecond;
    // Logger().d('updateKeyboardHeight:$ddd,$v');
    if (!_isVisible) {
      return;
    }
    debounce(() {
      // if (_keyboardHeight == v) {
      //   return;
      // }
      // _keyboardHeight = v;
      context.read<KeyboardProvider>().setKeyboardHeight(v);
      // setState(() {
      //   Logger().e('updateKeyboardHeight:$_keyboardHeight');
      // });
    }, 100);
  }

  Timer? _timer;
  void debounce(void Function() fn, [int t = 100]) {
    // Logger().e('message');
    // 还在时间之内，抛弃上一次
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: t), fn);
  }

  @override
  void initState() {
    // _keyboardHeight = context.read<KeyboardProvider>().keyboardHeight;
    // Logger().e('KeyboardProvider:$_keyboardHeight');
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    // print(
    //     'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      _isVisible = visible;
      widget.onChange?.call(visible);
      // print('Keyboard visibility update. Is visible: $visible');
    });

    super.initState();
  }

  ///
  @override
  void dispose() {
    // overlayEntry.remove();
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    updateKeyboardHeight(MediaQuery.of(context).viewInsets.bottom);
    super.didChangeDependencies();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // var keyboardHeight = context.watch<KeyboardProvider>().keyboardHeight;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // SystemChannels.textInput.invokeMethod('TextInput.show');
        },
        child: Selector<KeyboardProvider, double>(
          selector: (p0, p1) => p1.keyboardHeight,
          builder: (context, keyboardHeight, child) {
            return SizedBox(
              height: keyboardHeight,
              // decoration: const BoxDecoration(
              //   border: Border(
              //     top: BorderSide(
              //         color: Colors.black12,
              //         width: 0.5,
              //         style: BorderStyle.solid),
              //   ),
              // ),
              child: Center(
                child: child,
                //  ??
                //     const Text(
                //       'icpz.net',
                //       style: TextStyle(color: Colors.black12),
                //     ),
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'function_button.dart';

class LocationFunctionButton extends FunctionButton {
  ///

  ///
  const LocationFunctionButton({
    super.key,
    super.onSend,
  });

  ///
  @override
  String get text => '位置';

  ///
  @override
  IconData get icon => Icons.location_on_sharp;

  ///
  @override
  State<LocationFunctionButton> createState() => LocationFunctionButtonState();
}

class LocationFunctionButtonState<T extends FunctionButton>
    extends FunctionButtonState<T> {
  ///
  @override
  void onTap() {
    Logger().d('LocationFunctionButton');

    // Navigator.push(
    //     context,
    //     CupertinoPageRoute(
    //       builder: (context) => const LocationPage(),
    //     ));
  }
}

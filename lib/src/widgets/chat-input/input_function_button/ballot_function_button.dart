import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'function_button.dart';

class BallotFunctionButton extends FunctionButton {
  ///

  ///
  const BallotFunctionButton({
    super.key,
    super.onSend,
  });

  ///
  @override
  String get text => '投票';

  ///
  @override
  IconData get icon => Icons.ballot_rounded;

  ///
  @override
  State<BallotFunctionButton> createState() => BallotFunctionButtonState();
}

class BallotFunctionButtonState<T extends FunctionButton>
    extends FunctionButtonState<T> {
  ///
  @override
  void onTap() {
    Logger().d('BallotFunctionButton');
    // Navigator.push(
    //     context,
    //     CupertinoPageRoute(
    //       builder: (context) => const BallotPage(),
    //     ));
  }
}

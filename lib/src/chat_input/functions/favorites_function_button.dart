import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'function_button.dart';

class FavoritesFunctionButton extends FunctionButton {
  ///

  ///
  const FavoritesFunctionButton({
    super.key,
    super.onSend,
  });

  ///
  @override
  String get text => '收藏';

  ///
  @override
  IconData get icon => Icons.collections_bookmark;

  ///
  @override
  State<FavoritesFunctionButton> createState() =>
      FavoritesFunctionButtonState();
}

class FavoritesFunctionButtonState<T extends FunctionButton>
    extends FunctionButtonState<T> {
  ///
  @override
  void onTap() {
    Logger().d('FavoritesFunctionButton');

    // Navigator.push(
    //     context,
    //     CupertinoPageRoute(
    //       builder: (context) => const FavoritesPage(
    //         title: '请选择',
    //       ),
    //     ));
  }
}

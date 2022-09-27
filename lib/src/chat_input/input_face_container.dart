import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../commons/utils.dart';

/// Example for EmojiPickerFlutter
class InputFaceContainer extends StatefulWidget {
  const InputFaceContainer({
    Key? key,
    this.controller,
  }) : super(key: key);

  final TextEditingController? controller;
  @override
  createState() => _InputFaceContainerState();
}

class _InputFaceContainerState extends State<InputFaceContainer> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  ///
  bool emojiShowing = false;

  String insertText(String text, TextSelection selection, String inputValue) {
    String s = text.substring(0, selection.start);
    String e = text.substring(selection.end);
    return '$s$inputValue$e';
  }

  _onEmojiSelected(Emoji emoji) {
    var text = _controller.text;

    Utils.vibrateSuccess();

    if (text.isEmpty) {
      _controller
        ..text += emoji.emoji
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
      return;
    }

    ///
    var selection = _controller.selection;
    String s = text.substring(0, selection.start);
    String e = text.substring(selection.end);
    _controller.text = '$s${emoji.emoji}$e';
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: selection.start + emoji.emoji.length));
  }

  _onBackspacePressed() {
    Utils.vibrateSuccess();
    _controller
      ..text = _controller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
        onEmojiSelected: (Category category, Emoji emoji) {
          _onEmojiSelected(emoji);
        },
        onBackspacePressed: _onBackspacePressed,
        config: Config(
            columns: 7,
            // Issue: https://github.com/flutter/flutter/issues/28894
            emojiSizeMax: 28 * (Platform.isIOS ? 1.30 : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            initCategory: Category.RECENT,
            bgColor: Colors.transparent,
            indicatorColor: Colors.blue,
            iconColor: Colors.black54,
            iconColorSelected: Colors.blue,
            progressIndicatorColor: Colors.blue,
            backspaceColor: Colors.blue,
            skinToneDialogBgColor: Colors.white,
            skinToneIndicatorColor: Colors.grey,
            enableSkinTones: true,
            showRecentsTab: true,
            recentsLimit: 28,
            replaceEmojiOnLimitExceed: false,
            noRecents: const Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL));
  }
}

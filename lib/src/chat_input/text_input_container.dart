import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';

class TextInputContainer extends StatefulWidget {
  const TextInputContainer({
    Key? key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.hintText = '说点什么...',
    required this.inputMode,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final InputModeEnum inputMode;

  @override
  State<TextInputContainer> createState() => TextInputContainerState();
}

class TextInputContainerState extends State<TextInputContainer> {
  bool _readOnly = true;
  bool _enabled = true;
  bool _autofocus = true;

  bool get readOnly => _readOnly;
  bool get enabled => _enabled;
  bool get autofocus => _autofocus;

  // @override
  // bool get wantKeepAlive => true;

  ///
  void setReadOnly(bool value) {
    // Logger().e('setReadOnly:$value');
    // if (_readOnly == value) {
    //   return;
    // }
    setState(() {
      _readOnly = value;
    });
  }

  ///
  void setEnabled(bool value) {
    if (_enabled == value) {
      return;
    }
    setState(() {
      _enabled = value;
    });
  }

  ///
  void setAutofocus(bool value) {
    if (_autofocus == value) {
      return;
    }
    setState(() {
      _autofocus = value;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Expanded(
      child: Container(
        // height: 36,
        padding: const EdgeInsets.all(2.5),
        margin: const EdgeInsets.only(
          bottom: 2.5,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(175, 255, 255, 255),
          borderRadius: BorderRadius.circular(4.0),
        ),
        constraints: const BoxConstraints(
          minHeight: 36.0,
        ),
        child: Listener(
          onPointerDown: (event) {
            setReadOnly(false);
          },
          child: TextField(
            cursorColor: Colors.blue,
            showCursor: true,
            readOnly: _readOnly,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 64, 64, 64),
              height: 1.5,
            ),

            // textInputAction: TextInputAction.emergencyCall,
            autofocus: _autofocus,
            enabled: _enabled,
            maxLines: null,
            // maxLength: 5000,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(fontSize: 14.0),
                isDense: true,
                contentPadding: const EdgeInsets.all(5.0),
                border: const OutlineInputBorder(borderSide: BorderSide.none)),
            controller: widget.controller,
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ChoiceContainer extends StatefulWidget {
  const ChoiceContainer({
    Key? key,
    this.isChecked = false,
    this.size,
    this.margin,
    required this.child,
    this.onChanged,
    this.isChoiceMode = false,
    this.isIgnorePointer = true,
  }) : super(key: key);

  ///
  final bool isChoiceMode;

  ///
  final bool isChecked;

  ///
  final double? size;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  ///
  final ValueChanged<bool?>? onChanged;

  ///
  final bool isIgnorePointer;

  ///
  final Widget child;
  @override
  State<ChoiceContainer> createState() => _ChoiceContainerState();
}

class _ChoiceContainerState extends State<ChoiceContainer>
    with AutomaticKeepAliveClientMixin {
  /// 维护复选框状态
  bool _checkboxSelected = false;

  ///
  bool _isIgnorePointer = true;

  ///
  set isIgnorePointer(bool value) {
    setState(() {
      _isIgnorePointer = value;
    });
  }

  ///
  bool get isIgnorePointer => _isIgnorePointer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _checkboxSelected = widget.isChecked;
    _isIgnorePointer = widget.isIgnorePointer;
    super.initState();
  }

  ///
  void setValue(bool value) {
    if (_checkboxSelected == value) {
      return;
    }
    setState(() {
      _checkboxSelected = value;
      widget.onChanged?.call(_checkboxSelected);
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!widget.isChoiceMode) {
      return Container(margin: widget.margin, child: widget.child);
    }
    return InkWell(
      onTap: () {
        setValue(!_checkboxSelected);
      },
      onLongPress: () {
        setValue(!_checkboxSelected);
      },
      child: IgnorePointer(
        ignoring: _isIgnorePointer,
        child: Container(
          margin: widget.margin,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // margin: const EdgeInsets.only(right: 8),
                width: widget.size,
                height: widget.size,
                decoration: const BoxDecoration(
                    // color: Color.fromARGB(70, 244, 67, 54),
                    ),
                // constraints: BoxConstraints(),
                child: Center(
                  child: Transform.scale(
                    scale: 1.0,
                    child: Checkbox(
                      value: _checkboxSelected,
                      // activeColor: Colors.red, //选中时的颜色
                      tristate: false,
                      // splashRadius: 55,
                      // shape: const CircleBorder(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),

                      side: const BorderSide(
                          // width: 0.25,
                          // color: Color.fromARGB(255, 0, 0, 0),
                          ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) => setValue(value!),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: widget.child,
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'input_function_button/function_button.dart';

class InputFunctionContainer extends StatefulWidget {
  ///
  final List<List<FunctionButton>> pages;

  ///
  const InputFunctionContainer({
    Key? key,
    required this.pages,
  }) : super(key: key);

  @override
  State<InputFunctionContainer> createState() => _InputFunctionContainerState();
}

class _InputFunctionContainerState extends State<InputFunctionContainer> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.pages.length,
      child: Stack(
        children: [
          TabBarView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics()),
            children: widget.pages.map((page) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        children: page
                            .sublist(0, page.length > 8 ? 8 : page.length)
                            .map((item) {
                          return FractionallySizedBox(
                            widthFactor: 0.25,
                            child: item,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          widget.pages.length > 1
              ? const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    // height: 36,
                    child: TabPageSelector(
                      indicatorSize: 8,
                      // color: Colors.amber,
                      // selectedColor: Colors.amber.shade900,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

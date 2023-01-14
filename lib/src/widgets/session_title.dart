import 'package:flutter/material.dart';

import 'expand.dart';
import 'immersed_icon.dart';

class SessionTitle extends StatefulWidget {
  const SessionTitle({
    super.key,
    required this.title,
    this.subTitle,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isImmersed = false,
  });

  final String title;

  final String? subTitle;

  final CrossAxisAlignment crossAxisAlignment;

  final bool isImmersed;

  @override
  State<SessionTitle> createState() => _SessionTitleState();
}

class _SessionTitleState extends State<SessionTitle> {
  @override
  Widget build(BuildContext context) {
    return Expand(
      // fixed: const ImmersedIcon(visible: true),
      child: Column(
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [titleWidget(), subTitleWidget()],
      ),
    );
  }

  Widget titleWidget() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.title,
              style: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              )),
          ImmersedIcon(visible: widget.isImmersed),
        ],
      ),
    );
  }

  Widget subTitleWidget() {
    if (widget.subTitle == null) {
      return Container();
    }

    return Text(widget.subTitle!,
        style: const TextStyle(
          color: Colors.black38,
          fontSize: 10,
          overflow: TextOverflow.ellipsis,
        ));
  }
}

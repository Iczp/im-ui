import 'package:flutter/material.dart';

import 'session_immersed.dart';
import '../widgets/expand.dart';

class SessionTitle extends StatefulWidget {
  const SessionTitle({
    super.key,
    required this.title,
    this.subTitle,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.sessionUnitId,
  });

  final String title;

  final String? subTitle;

  final String sessionUnitId;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<SessionTitle> createState() => _SessionTitleState();
}

class _SessionTitleState extends State<SessionTitle> {
  get sessionUnitId => widget.sessionUnitId;

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
          SessionImmersed(sessionUnitId: sessionUnitId)
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

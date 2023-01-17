import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers.dart';
import '../widgets/star_icon.dart';

class SessionTopping extends StatelessWidget {
  const SessionTopping({
    super.key,
    required this.sessionUnitId,
  });

  /// sessionUnitId
  final String sessionUnitId;

  @override
  Widget build(BuildContext context) {
    return Selector<SessionUnitProvider, bool?>(
      selector: ((_, x) => x.getTopping(sessionUnitId)),
      builder: (_, value, child) {
        return StarIcon(
          visible: value!,
          color: const Color.fromARGB(255, 234, 137, 0),
        );
      },
    );
  }
}

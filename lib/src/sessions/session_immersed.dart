import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers.dart';
import '../widgets/immersed_icon.dart';

class SessionImmersed extends StatelessWidget {
  const SessionImmersed({
    super.key,
    required this.sessionUnitId,
  });

  /// sessionUnitId
  final String sessionUnitId;

  @override
  Widget build(BuildContext context) {
    return Selector<SessionUnitProvider, bool?>(
      selector: ((_, x) => x.getImmersed(sessionUnitId) ?? false),
      builder: (_, value, child) {
        return ImmersedIcon(visible: value!);
      },
    );
  }
}

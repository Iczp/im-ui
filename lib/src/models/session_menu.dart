import 'dart:convert';

enum SessionAction {
  topping,
  immersed,
  display,
  delete,
}

class SessionMenu {
  ///
  SessionMenu({
    required this.id,
    required this.trueText,
    required this.value,
    required this.falseText,
  });

  final String id;

  final bool value;

  final String trueText;

  final String falseText;

  @override
  String toString() {
    return jsonEncode({
      'id': id,
      'value': value,
      'trueText': trueText,
      'falseText': falseText,
    });
  }
}

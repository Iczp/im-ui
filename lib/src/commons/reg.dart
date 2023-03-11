class Reg {
  /// 是否 josn
  static bool isJson(String input) {
    RegExp jsonRegex = RegExp(
      r'^\s*(?:\{.*\}|\[.*\])\s*$',
      multiLine: true,
      caseSensitive: true,
    );
    bool isJson = jsonRegex.hasMatch(input);
    return isJson;
  }
}

class ResultModel<T> {
  ///
  ResultModel({
    required this.isSuccess,
    this.data,
    this.message,
  });

  ///
  late bool isSuccess;

  ///
  late String? message;

  ///
  late T? data;
}

/// SizeModel T<double>
class SizeModel extends SizeModelT<double> {
  ///
  SizeModel(super.width, super.height);
}

/// int
class SizeIntModel extends SizeModelT<int> {
  ///
  SizeIntModel(super.width, super.height);
}

/// double
class SizeDoubleModel extends SizeModelT<double> {
  ///
  SizeDoubleModel(super.width, super.height);
}

/// SizeModel T
class SizeModelT<T> {
  ///
  final T width;

  ///
  final T height;

  ///
  SizeModelT(this.width, this.height);

  ///
  SizeModelT.build({
    required this.width,
    required this.height,
  });
}

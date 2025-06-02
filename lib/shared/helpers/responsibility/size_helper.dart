class SizeHelper {
  factory SizeHelper() {
    return _instance;
  }
  SizeHelper._();
  static final SizeHelper _instance = SizeHelper._();

  double _screenWidth = 600;
  double _screenHeight = 300;

  void setSizeScreen({required double width, required double height}) {
    _screenWidth = width;
    _screenHeight = height;
  }

  double get screenWidth => _screenWidth.toDouble();
  double get screenHeight => _screenHeight.toDouble();
}

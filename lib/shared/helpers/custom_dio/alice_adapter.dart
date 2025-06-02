import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';

class AliceAdapter {
  AliceAdapter._(GlobalKey<NavigatorState> key) {
    alice = Alice(
      navigatorKey: key,
      darkTheme: true,
      showNotification: false,
    );
  }

  static AliceAdapter? _i;
  static late Alice alice;

  static AliceAdapter instance(GlobalKey<NavigatorState> key) {
    return _i ??= AliceAdapter._(key);
  }

  static bool hasInstance() {
    return _i != null;
  }
}

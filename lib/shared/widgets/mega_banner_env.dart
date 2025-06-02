import 'dart:async';

import 'package:flutter/material.dart';

import '../../mega_commons.dart';
import '../models/abbreviation.dart';

class MegaBannerEnv extends StatefulWidget {
  const MegaBannerEnv({
    super.key,
    required this.child,
    this.devColor = Colors.red,
    this.hmlColor = Colors.purple,
    this.location = BannerLocation.bottomStart,
    required this.navigationKey,
  });

  final Widget child;
  final Color devColor, hmlColor;
  final BannerLocation location;
  final GlobalKey<NavigatorState> navigationKey;

  @override
  State<MegaBannerEnv> createState() => _MegaBannerEnvState();
}

class _MegaBannerEnvState extends State<MegaBannerEnv> {
  int _tapCount = 0;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    AliceAdapter.alice.setNavigatorKey(widget.navigationKey);
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    _resetTimer?.cancel();
    setState(() {
      _tapCount++;
    });

    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _tapCount = 0;
        });
      }
    });
  }

  void _handleLongPress() {
    if (_tapCount >= 3) {
      AliceAdapter.alice.showInspector();
      setState(() {
        _tapCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final environmentData = EnvironmentUrl.fromCache();
    if (environmentData?.abbreviation == Abbreviation.production) {
      return widget.child;
    }
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _handleLongPress,
      child: Banner(
        message: environmentData?.name ?? 'DEV',
        location: widget.location,
        color: environmentData?.abbreviation == Abbreviation.development
            ? widget.devColor
            : widget.hmlColor,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        child: widget.child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../mega_commons.dart';

class MegaVersionIndicator extends StatefulWidget {
  const MegaVersionIndicator({
    super.key,
    this.textColor,
    this.fontSize = 12,
  });

  final Color? textColor;
  final double fontSize;

  @override
  State<MegaVersionIndicator> createState() => _MegaVersionIndicatorState();
}

class _MegaVersionIndicatorState extends State<MegaVersionIndicator> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final EnvironmentUrl? environmentData = EnvironmentUrl.fromCache();
    final pack = await PackageInfo.fromPlatform();

    final String version = pack.version;
    final String buildNumber = pack.buildNumber;
    setState(() {
      if (environmentData != null) {
        final letter = environmentData.abbreviation.letter;
        _appVersion = '$letter $version ($buildNumber)';
        MegaLogger.info(
          'Version: $_appVersion ${environmentData.abbreviation.firebase}',
        );
      } else {
        _appVersion = '$version ($buildNumber)';
        MegaLogger.info('Version: $_appVersion');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _appVersion,
      style: TextStyle(
        color: widget.textColor,
        fontSize: widget.fontSize,
      ),
    );
  }
}

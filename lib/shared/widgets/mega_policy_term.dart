import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../mega_commons.dart';
import 'mega_radio_button.dart';

class MegaPolicyTerm extends StatelessWidget {
  const MegaPolicyTerm({
    super.key,
    this.label,
    this.isSelected = false,
    this.unselectedColor,
    required this.onChanged,
    required this.policyTermsFileUrl,
    this.color,
  });

  final String? label;
  final bool isSelected;
  final Function(bool) onChanged;
  final String policyTermsFileUrl;
  final Color? color;
  final Color? unselectedColor;

  Future<void> openLink() async {
    final environmentData = EnvironmentUrl.fromCache();
    final baseUrl = environmentData?.url ?? '';

    String url = '$baseUrl$policyTermsFileUrl';
    if (policyTermsFileUrl.contains('http')) {
      url = policyTermsFileUrl;
    }

    final uri = Uri.parse(url);

    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Row(
        children: [
          MegaRadioButton(
            isSelected: isSelected,
            selectedColor: color ?? Theme.of(context).colorScheme.secondary,
            unselectedColor: unselectedColor ?? Colors.black45,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'Eu li e concordo os ',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                children: [
                  TextSpan(
                    text: 'termos de uso da plataforma',
                    style: TextStyle(
                      color: color ?? Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await openLink();
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

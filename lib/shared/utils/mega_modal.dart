import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';
import 'package:restart_app/restart_app.dart';

import '../../mega_commons.dart';
import '../models/abbreviation.dart';

sealed class MegaModal {
  static Future<void> callEnvironmentModal(
    BuildContext context, {
    required String devUrl,
    required String hmlUrl,
    required String prodUrl,
  }) async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 1),
      ),
    );
    await remoteConfig.fetchAndActivate();
    final canShowModal = remoteConfig.getBool('environment_modal');
    if (!canShowModal) {
      return;
    }
    final customUrlController =
        TextEditingController(text: '');
    final formKey = GlobalKey<FormState>();

    if (!context.mounted) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                '🔧 Escolha um ambiente para o APP 🔧',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const Text(
                '⚠️ Reinicie o APP após a troca de ambiente ⚠️',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              MegaBaseButton(
                'DEV',
                buttonColor: context.theme.primaryColor,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
                onButtonPress: () async {
                  await _saveEnvBaseUrl(
                    context,
                    abbreviation: Abbreviation.development,
                    baseUrl: devUrl,
                  );
                },
              ),
              const SizedBox(height: 12),
              MegaBaseButton(
                'HML',
                buttonColor: context.theme.primaryColor,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                onButtonPress: () async {
                  await _saveEnvBaseUrl(
                    context,
                    abbreviation: Abbreviation.homolog,
                    baseUrl: hmlUrl,
                  );
                },
              ),
              const SizedBox(height: 12),
              MegaBaseButton(
                'PROD',
                buttonColor: context.theme.primaryColor,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                onButtonPress: () async {
                  await _saveEnvBaseUrl(
                    context,
                    abbreviation: Abbreviation.production,
                    baseUrl: prodUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: MegaTextFieldWidget(
                        customUrlController,
                        labelText: 'Custom',
                        hintText: 'https://api.megaleios.com/',
                        validator: (value) {
                          if (!isURL(value)) {
                            return 'Informe uma URL válida';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        await _saveEnvBaseUrl(
                          context,
                          abbreviation: Abbreviation.custom,
                          baseUrl: customUrlController.text,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.floppyDisk,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              MegaBaseButton(
                'Cancelar',
                buttonColor: const Color(0xFFFF0000),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                onButtonPress: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> _saveEnvBaseUrl(
    BuildContext context, {
    required Abbreviation abbreviation,
    required String baseUrl,
  }) async {
    final environmentUrl = EnvironmentUrl(
      abbreviation: abbreviation,
      name: abbreviation.name,
      url: baseUrl,
    );
    await EnvironmentUrl.save(environmentUrl);
    if (context.mounted) {
      Navigator.pop(context);
    }
    if (!kIsWeb && Platform.isAndroid) {
      Restart.restartApp();
    }
  }

  static void showConfirmCancel(
    BuildContext context, {
    required String message,
    required VoidCallback onSuccess,
    String? title,
    String? confirmLabel,
    String? cancelLabel,
    bool? canDismiss,
    VoidCallback? onCancel,
    Color? confirmButtonColor,
    Color? cancelTextColor,
    Color? confirmTextColor,
    IconData? iconData,
    String? svgIcon,
  }) {
    final isDark = context.theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: canDismiss ?? true,
      builder: (context) => Dialog(
        surfaceTintColor: isDark ? null : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: BodyModal(
          message: message,
          title: title,
          iconData: iconData,
          svgIcon: svgIcon,
          canDismiss: canDismiss,
          bottomContainer: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  cancelLabel ?? 'Não',
                  style: TextStyle(
                    fontSize: 16,
                    color: cancelTextColor ??
                        (isDark ? Colors.white54 : Colors.black54),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: onSuccess,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: confirmButtonColor ??
                        context.theme.colorScheme.secondary,
                  ),
                  child: Text(
                    confirmLabel ?? 'Sim',
                    style: TextStyle(
                      fontSize: 16,
                      color: confirmTextColor ?? Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showConfirm(
    BuildContext context, {
    required String message,
    String? title,
    String? okLabel,
    bool? canDismiss,
    VoidCallback? onOk,
    Color? okButtonColor,
    Color? okTextColor,
  }) {
    final isDark = context.theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: canDismiss ?? true,
      builder: (context) => Dialog(
        surfaceTintColor: isDark ? null : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: BodyModal(
          message: message,
          title: title,
          canDismiss: canDismiss,
          bottomContainer: Center(
            child: InkWell(
              onTap: () {
                onOk?.call();
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: okButtonColor ?? context.theme.colorScheme.secondary,
                ),
                child: Text(
                  okLabel ?? 'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: okTextColor ?? Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BodyModal extends StatelessWidget {
  const BodyModal({
    super.key,
    required this.message,
    required this.bottomContainer,
    this.title,
    this.canDismiss,
    this.iconData,
    this.backgroundIconColor,
    this.svgIcon,
  });
  final String message;
  final Widget bottomContainer;
  final String? title;
  final bool? canDismiss;
  final IconData? iconData;
  final Color? backgroundIconColor;
  final String? svgIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final theme = context.theme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
          child: Row(
            spacing: 8,
            children: [
              Visibility(
                visible: iconData != null || svgIcon != null,
                child: Container(
                  height: 34,
                  width: 34,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: backgroundIconColor ?? theme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: iconData != null
                      ? Icon(
                          iconData,
                          color: Colors.white,
                          size: 18,
                        )
                      : SvgPicture.asset(
                          svgIcon ?? '',
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          height: 18,
                          width: 18,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Visibility(
                visible: canDismiss ?? true,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    FontAwesomeIcons.circleXmark,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(message),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: isDark ? const Color(0xFF1C1B1F) : const Color(0xFFF0F0F0),
          ),
          child: bottomContainer,
        ),
      ],
    );
  }
}

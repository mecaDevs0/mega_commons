import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../mega_commons.dart';

class MegaPermission {
  MegaPermission._();

  static Future<bool> storage() async {
    await Permission.storage.request();
    if (await Permission.storage.isGranted) {
      return true;
    } else if (await Permission.storage.isDenied) {
      await Permission.storage.request();
      if (await Permission.storage.isGranted) {
        return true;
      } else {
        MegaSnackbar.showErroSnackBar(
          'Você cancela a autorização de armazenamento de arquivos',
        );
        return false;
      }
    } else if (await Permission.storage.isPermanentlyDenied) {
      MegaSnackbar.showErroSnackBar(
        'Você recusou a autorização de armazenamento de arquivos, por favor, abri-lo nas configurações',
      );
      return false;
    } else {
      MegaSnackbar.showErroSnackBar(
        'Erro desconhecido de autorização de armazenamento de arquivos',
      );
      return false;
    }
  }

  static Future<bool> isLocationPermissionGranted() async {
    final serviceEnabled =
        await GeolocatorPlatform.instance.isLocationServiceEnabled();
    if (!serviceEnabled) {
      MegaSnackbar.showErroSnackBar(
        'O serviço de localização está desativado, por favor, ative-o nas configurações',
      );
      return false;
    }
    await Permission.location.request();
    if (await Permission.location.isGranted) {
      return true;
    } else if (await Permission.location.isDenied) {
      await Permission.location.request();
      if (await Permission.location.isGranted) {
        return true;
      } else {
        MegaSnackbar.showErroSnackBar(
          'Você recusou a autorização de localização, por favor, abri-lo nas configurações',
        );
        return false;
      }
    } else if (await Permission.location.isPermanentlyDenied) {
      MegaSnackbar.showErroSnackBar(
        'Você recusou a autorização de localização, por favor, abri-lo nas configurações',
      );
      return false;
    } else {
      MegaSnackbar.showErroSnackBar(
        'Erro desconhecido de autorização de localização',
      );
      return false;
    }
  }

  static Future<bool> isPermissionGranted(
    BuildContext context, {
    required Permission permission,
    required String namePermission,
  }) async {
    final status = await permission.request();
    if (status == PermissionStatus.permanentlyDenied && context.mounted) {
      await openSettingPermissionModal(
        context,
        namePermission: namePermission,
      );
    }
    return status == PermissionStatus.granted;
  }

  static Future<void> openSettingPermissionModal(
    BuildContext context, {
    required String namePermission,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Permissão negada!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Você recusou a autorização de $namePermission, por favor, abri-lo nas configurações',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                const Color(0xFF7EBD6D),
                              ),
                            ),
                            child: const Text('Ok'),
                            onPressed: () async {
                              final open = await openAppSettings();
                              if (open) {
                                if (!context.mounted) {
                                  return;
                                }

                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -20,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6347),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.clear_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class MegaContainerLoading extends StatelessWidget {
  const MegaContainerLoading({
    super.key,
    required this.child,
    required this.isLoading,
    this.colorLoading,
    this.textLoading,
    this.textColor,
    this.backgroundColor,
    this.loadingWidget,
  });

  final Widget child;
  final bool isLoading;
  final Color? colorLoading;
  final Color? textColor;
  final String? textLoading;
  final Color? backgroundColor;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Visibility(
            visible: isLoading,
            child: Container(
              color: backgroundColor ?? Colors.black.withValues(alpha: 0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loadingWidget ??
                      SpinKitWave(
                        itemCount: 4,
                        itemBuilder: (_, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorLoading ?? Colors.white,
                            ),
                          );
                        },
                        size: 20,
                      ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      textLoading ?? 'Carregando...',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: textColor ?? Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

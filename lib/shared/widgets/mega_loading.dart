import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class MegaLoading extends StatelessWidget {
  const MegaLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 10,
        child: SpinKitWave(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
              ),
            );
          },
          size: 20,
        ),
      ),
    );
  }
}

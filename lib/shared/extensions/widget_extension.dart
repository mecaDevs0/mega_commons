import 'package:flutter/widgets.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

extension WidgetExtensions on Widget {
  /// Aplica o efeito de shimmer por sombra
  Widget get shade {
    return Skeleton.shade(child: this);
  }

  /// Aplica o efeito shimmer de container
  Widget get leaf {
    return Skeleton.leaf(child: this);
  }

  /// Aplica o efeito shimmer de unificar
  Widget get unite {
    return Skeleton.unite(child: this);
  }

  /// Aplica a animação de fadeIn com duração de 300ms
  Animate get fadeIn {
    return animate().fadeIn(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  /// Aplica a animação de fadeIn e scale
  /// [fadeDuration] é o tempo de duração da animação de fadeIn
  /// [scaleDelay] é o tempo de atraso da animação de scale
  Animate fadeInAndScale({
    int fadeDuration = 300,
    int scaleDelay = 300,
  }) {
    return animate()
        .fade(duration: fadeDuration.ms)
        .scale(delay: scaleDelay.ms);
  }

  /// Aplica a animação de mover para cima
  /// [begin] é o valor inicial da animação
  Animate moveUp({
    double begin = 20,
  }) {
    return animate().moveY(
      begin: begin,
      end: 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  /// Aplica a animação de mover para baixo
  /// [begin] é o valor inicial da animação
  Animate moveDown({
    double begin = -20,
  }) {
    return animate().moveY(
      begin: begin,
      end: 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  /// Aplica a animação de zoom com a de fadeIn
  /// [duration] é o tempo de duração da animação
  Animate zoomInFade({
    int duration = 300,
    Offset begin = const Offset(0.5, 0.5),
  }) {
    return animate()
        .scale(
          begin: begin,
          end: const Offset(1.0, 1.0),
          duration: duration.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: duration.ms);
  }

  /// Aplica a animação de mostrar/esconder
  /// [duration] é o tempo de duração da animação
  /// [offset] é o valor inicial da animação
  Animate slideFadeToggle({
    double offset = 20,
    int duration = 300,
  }) {
    return animate().fade(duration: duration.ms).moveY(
          begin: offset,
          end: 0,
          duration: duration.ms,
          curve: Curves.easeInOut,
        );
  }

  Animate fadeInFromLeft({
    double offset = -30,
    int duration = 300,
  }) {
    return animate().fadeIn(duration: duration.ms).moveX(
          begin: offset,
          end: 0,
          duration: duration.ms,
          curve: Curves.easeOut,
        );
  }
}

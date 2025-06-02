import 'package:flutter/material.dart';

class MegaRadioButton extends StatefulWidget {
  const MegaRadioButton({
    super.key,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  State<MegaRadioButton> createState() => _BaseRadioButtonState();

  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
}

class _BaseRadioButtonState extends State<MegaRadioButton>
    with TickerProviderStateMixin {
  late AnimationController selectedAnimationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  void prepareAnimations() {
    selectedAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: selectedAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (widget.isSelected) {
      selectedAnimationController.forward();
    } else {
      selectedAnimationController.reverse();
    }
  }

  @override
  void didUpdateWidget(MegaRadioButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    selectedAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isSelected
                    ? widget.selectedColor
                    : widget.unselectedColor.withValues(alpha: 0.5),
                width: 2,
              ),
              color: Colors.transparent,
            ),
          ),
          ScaleTransition(
            scale: animation,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: widget.selectedColor,
                ),
                height: 14,
                width: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../mega_commons.dart';

enum MegaDropTypeModal { none, bottom, dialog }

class MegaDropDownWidget<T> extends StatefulWidget {
  const MegaDropDownWidget({
    super.key,
    required this.controller,
    this.label,
    this.title,
    required this.listDropDownItem,
    this.onChanged,
    this.onClear,
    this.isRequired = false,
    this.hintText,
    this.labelStyleColor,
    this.fontColor,
    this.emptyWidget,
    this.prefixIcon,
    this.suffixIcon,
    this.isEnabled,
    this.canOpenModal = true,
    this.notOpenModalMessage = 'Não é possível abrir o modal',
    this.isModalDialog = false,
    this.validator,
    this.backgroundColor,
    this.typeModal = MegaDropTypeModal.bottom,
    this.overlayOffset = 0,
  });

  final TextEditingController controller;
  final String? label;
  final String? title;
  final List<MegaItemWidget<T>> listDropDownItem;
  final Function(T)? onChanged;
  final Function()? onClear;
  final bool isRequired;
  final String? hintText;
  final Color? labelStyleColor;
  final Color? fontColor;
  final Widget? emptyWidget;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isEnabled;
  final bool? canOpenModal;
  final String? notOpenModalMessage;
  @Deprecated(
    'Use typeModal ao invés disso. isModalDialog será removido em uma versão futura.',
  )
  final bool? isModalDialog;
  final String? Function(String?)? validator;
  final Color? backgroundColor;
  final MegaDropTypeModal typeModal;
  final double overlayOffset;

  @override
  State<MegaDropDownWidget<T>> createState() => _MegaDropDownWidgetState<T>();
}

class _MegaDropDownWidgetState<T> extends State<MegaDropDownWidget<T>> {
  final _textFieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showDropdown();
    } else {
      _hideDropdown();
    }
  }

  void _showDropdown() {
    final renderBox =
        _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _hideDropdown,
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.black.withValues(alpha: 0.05),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height - widget.overlayOffset,
              width: size.width,
              child: Material(
                borderRadius: BorderRadius.circular(8),
                elevation: 4,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: context.height * 0.4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24),
                    shrinkWrap: true,
                    itemCount: widget.listDropDownItem.length,
                    itemBuilder: (context, index) {
                      final item = widget.listDropDownItem[index];
                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.onClear?.call();
                                _hideDropdown();
                              },
                              child: Text(widget.title ?? ''),
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                          ],
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          widget.onChanged?.call(item.value);
                          _hideDropdown();
                        },
                        child: item,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _openModalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  widget.title ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: widget.listDropDownItem.isNotEmpty,
                  replacement: widget.emptyWidget ??
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Lista vazia!',
                            style: TextStyle(),
                          ),
                        ),
                      ),
                  child: Flexible(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          children: widget.listDropDownItem
                              .map(
                                (item) => GestureDetector(
                                  onTap: () {
                                    widget.onChanged!(item.value);
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    children: [
                                      const Divider(),
                                      item,
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
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

  void _showBottomModal(BuildContext context) {
    final height = context.height;
    final background =
        widget.backgroundColor ?? Theme.of(context).dialogBackgroundColor;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            minHeight: 100,
            minWidth: double.maxFinite,
            maxHeight: height * 0.7,
          ),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(24),
                    ),
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  widget.title ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Visibility(
                visible: widget.listDropDownItem.isNotEmpty,
                replacement: widget.emptyWidget ??
                    const Center(
                      child: Text('Lista vazia!'),
                    ),
                child: Flexible(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: widget.listDropDownItem
                            .map(
                              (item) => GestureDetector(
                                onTap: () {
                                  widget.onChanged!(item.value);
                                  Navigator.pop(context);
                                },
                                child: item,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MegaTextFieldWidget(
      key: _textFieldKey,
      widget.controller,
      labelText: widget.label,
      isRequired: widget.isRequired,
      isReadOnly: true,
      hintText: widget.hintText,
      fontColor: widget.fontColor,
      isEnabled: widget.isEnabled,
      validator: widget.validator,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon ??
          Icon(
            FontAwesomeIcons.chevronDown,
            size: 12,
            color: context.theme.colorScheme.primary,
          ),
      onTap: () {
        if (widget.canOpenModal == false) {
          MegaSnackbar.showToast(widget.notOpenModalMessage!);
          FocusScope.of(context).unfocus();
          return;
        }
        if (widget.isModalDialog == true) {
          _openModalDialog(context);
          return;
        }

        return switch (widget.typeModal) {
          MegaDropTypeModal.none => _toggleDropdown(),
          MegaDropTypeModal.bottom => _showBottomModal(context),
          MegaDropTypeModal.dialog => _openModalDialog(context),
        };
      },
    );
  }
}

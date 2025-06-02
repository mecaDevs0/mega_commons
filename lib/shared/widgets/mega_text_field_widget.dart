import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../mega_commons.dart';

/// MegaTextFieldWidget:
///
class MegaTextFieldWidget extends StatefulWidget {
  const MegaTextFieldWidget(
    this.textEditingController, {
    super.key,
    this.onSaved,
    this.validator,
    this.labelText,
    this.onChanged,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.isReadOnly = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.fontColor,
    this.labelFontColor,
    this.hintText,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.autofillHints,
    this.onEditingComplete,
    this.focusNode,
    this.isEnabled = true,
    this.inputFormatters,
    this.maxLength,
    this.onFieldSubmitted,
    this.helperText,
    this.textCapitalization,
    this.topPadding,
  });
  final TextEditingController? textEditingController;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Function(String?)? onChanged;
  final String? labelText;
  final bool isReadOnly;
  final int maxLines;
  final int minLines;
  final Color? fontColor;
  final Color? labelFontColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final bool isRequired;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;
  final bool? isEnabled;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final Function(String)? onFieldSubmitted;
  final String? helperText;
  final TextCapitalization? textCapitalization;
  final double? topPadding;

  @override
  _MegaTextFieldWidgetState createState() => _MegaTextFieldWidgetState();
}

class _MegaTextFieldWidgetState extends State<MegaTextFieldWidget> {
  bool obscureText = false;

  @override
  void initState() {
    setState(() {
      obscureText = widget.keyboardType == TextInputType.visiblePassword;
    });
    super.initState();
  }

  String? Function(String?)? getValidator() {
    if (widget.validator != null) {
      return widget.validator;
    }
    List<FormFieldValidator<String>> validators =
        <FormFieldValidator<String>>[];
    if (widget.isRequired) {
      validators = <FormFieldValidator<String>>[
        ...validators,
        ...<FormFieldValidator<String>>[
          Validators.requiredEmpty(
            '${widget.labelText ?? 'Campo'} é obrigatório',
          ),
        ],
      ];
    }
    return Validatorless.multiple(validators);
  }

  @override
  Widget build(BuildContext context) {
    final bool isPassword =
        widget.keyboardType == TextInputType.visiblePassword;

    return Padding(
      padding: EdgeInsets.only(top: widget.topPadding ?? 10),
      child: TextFormField(
        enabled: widget.isEnabled,
        readOnly: widget.isReadOnly,
        controller: widget.textEditingController,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        autocorrect: widget.keyboardType != TextInputType.emailAddress,
        enableSuggestions: widget.keyboardType != TextInputType.emailAddress,
        minLines: widget.minLines,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        onEditingComplete: widget.onEditingComplete,
        inputFormatters: widget.inputFormatters,
        enableInteractiveSelection: true,
        maxLength: widget.maxLength,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        style: TextStyle(color: widget.fontColor),
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: context.theme.inputDecorationTheme.hintStyle ??
              TextStyle(color: widget.fontColor),
          labelStyle: context.theme.inputDecorationTheme.labelStyle ??
              TextStyle(color: widget.labelFontColor),
          suffixIcon: validSuffix(isPassword: isPassword),
          prefixIcon: widget.prefixIcon,
          helperText: widget.helperText,
          prefixIconConstraints: const BoxConstraints(
            minHeight: 38,
            minWidth: 38,
          ),
          suffixIconConstraints: const BoxConstraints(
            minHeight: 38,
            minWidth: 38,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: widget.labelText == null ? 14 : 8,
            horizontal: 10,
          ),
        ),
        validator: getValidator(),
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        focusNode: widget.focusNode,
        onTap: widget.onTap,
      ),
    );
  }

  Widget? validSuffix({bool? isPassword}) {
    return isPassword!
        ? InkWell(
            onTap: onShowHidePasswordPress,
            child: SuffixPasswordIcon(obscureText: obscureText),
          )
        : widget.suffixIcon;
  }

  void onShowHidePasswordPress() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}

class SuffixPasswordIcon extends StatelessWidget {
  const SuffixPasswordIcon({
    super.key,
    required this.obscureText,
  });

  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Icon(
      obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
      size: 18,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khazana_mutual_funds/core/utils/validators.dart';

class InputField extends StatefulWidget {
  const InputField({
    required this.controller,
    required this.label,
    this.textInputAction = TextInputAction.go,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
    this.borderRadius,
    this.filledColor,
    this.borderColor,
    this.readOnly,
    this.onTap,
    this.textStyle,
    this.onChanged,
    this.charLimit,
    this.errorText,
    super.key,
  });

  const InputField.name({
    required TextEditingController controller,
    String? label,
    TextInputAction textInputAction = TextInputAction.next,
    TextStyle? textStyle,
    int? charLimit,
    String? errorText,
    Key? key,
  }) : this(
         key: key,
         controller: controller,
         label: label ?? "Name",
         textInputAction: textInputAction,
         keyboardType: TextInputType.name,
         autofillHints: const [AutofillHints.name],
         validator: Validators.required,
         charLimit: charLimit,
         textStyle: textStyle,
         errorText: errorText,
       );

  const InputField.email({
    required TextEditingController controller,
    String? label,
    TextInputAction textInputAction = TextInputAction.next,
    TextStyle? textStyle,
    String? errorText,
    Key? key,
  }) : this(
         key: key,
         controller: controller,
         label: label ?? "Email",
         textInputAction: textInputAction,
         keyboardType: TextInputType.emailAddress,
         autofillHints: const [AutofillHints.email],
         validator: Validators.email,
         textStyle: textStyle,
         errorText: errorText,
       );

  const InputField.password({
    required TextEditingController controller,
    String? label,
    TextInputAction textInputAction = TextInputAction.next,
    ValueChanged<String>? onFieldSubmitted,
    TextStyle? textStyle,
    String? errorText,
    Key? key,
  }) : this(
         key: key,
         controller: controller,
         label: label ?? "Password",
         textInputAction: textInputAction,
         keyboardType: TextInputType.visiblePassword,
         autofillHints: const [AutofillHints.password],
         validator: Validators.password,
         onFieldSubmitted: onFieldSubmitted,
         textStyle: textStyle,
         errorText: errorText,
       );

  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final double? borderRadius;
  final Color? filledColor;
  final Color? borderColor;
  final bool? readOnly;
  final void Function()? onTap;
  final TextStyle? textStyle;
  final int? charLimit;
  final void Function(String)? onChanged;
  final String? errorText;
  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;
  late bool _isPassword;

  @override
  void initState() {
    _isPassword = widget.keyboardType == TextInputType.visiblePassword;
    _obscureText = _isPassword;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InputField oldWidget) {
    if (oldWidget.keyboardType != widget.keyboardType) {
      _isPassword = widget.keyboardType == TextInputType.visiblePassword;
      _obscureText = _isPassword;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final validator =
        widget.validator ?? Validators.getValidator(widget.keyboardType);

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      validator: validator,
      readOnly: widget.readOnly ?? false,
      autofillHints: widget.autofillHints,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: widget.textStyle ?? TextStyle(fontSize: 18),
      maxLength: widget.charLimit,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 14),
          borderSide: BorderSide(
            color: widget.borderColor ?? Theme.of(context).colorScheme.outline,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 14),
          borderSide: BorderSide(
            color: widget.borderColor ?? Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 14),
          borderSide: BorderSide(
            color: widget.borderColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        filled: widget.filledColor != null,
        fillColor:
            widget.filledColor ??
            Theme.of(context).colorScheme.surfaceContainerHigh,
        hintText: widget.label,
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        suffixIcon:
            _isPassword
                ? IconButton(
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                  icon:
                      _obscureText
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility_sharp),
                )
                : null,
        errorText: widget.errorText,
      ),
    );
  }
}

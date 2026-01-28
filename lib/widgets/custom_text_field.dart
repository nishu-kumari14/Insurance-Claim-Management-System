import 'package:flutter/material.dart';
import 'package:insurance_claim_system/utils/constants.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final int minLines;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? initialValue;
  final VoidCallback? onTap;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final bool showValidationIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.minLines = 1,
    this.obscureText = false,
    this.suffixIcon,
    this.initialValue,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.showValidationIcon = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  String? _errorMessage;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _hasContent = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_validateOnChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateOnChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _validateOnChange() {
    if (mounted) {
      setState(() {
        _hasContent = widget.controller.text.isNotEmpty;
        if (widget.validator != null && _hasContent) {
          _errorMessage = widget.validator!(widget.controller.text);
        } else {
          _errorMessage = null;
        }
      });
      widget.onChanged?.call(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          obscureText: widget.obscureText,
          initialValue: widget.initialValue,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            suffixIcon: widget.showValidationIcon && _hasContent && !widget.readOnly
                ? Padding(
                    padding: const EdgeInsets.only(right: AppDimens.paddingSmall),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _errorMessage == null
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              key: ValueKey('valid'),
                            )
                          : const Icon(
                              Icons.error,
                              color: AppColors.error,
                              key: ValueKey('invalid'),
                            ),
                    ),
                  )
                : widget.suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.borderRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.borderRadius),
              borderSide: const BorderSide(color: AppColors.greyLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.borderRadius),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.borderRadius),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.borderRadius),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.all(AppDimens.padding),
          ),
        ),
        if (_errorMessage != null && _hasContent)
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimens.paddingXSmall,
              left: AppDimens.paddingSmall,
            ),
            child: AnimatedOpacity(
              opacity: _errorMessage != null ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                _errorMessage ?? '',
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

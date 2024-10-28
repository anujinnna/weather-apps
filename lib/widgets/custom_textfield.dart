import 'package:flutter/material.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:weather_app/themes/custom_fonts.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? leadIcon;
  final bool icon;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.leadIcon,
    required this.icon,
    required this.hintText,
    required this.obscureText,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obScure = true;
  bool isFieldActive = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    obScure = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isFieldActive = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: obScure,
      focusNode: _focusNode,
      decoration: InputDecoration(
        prefixIcon: widget.leadIcon != null ? Icon(widget.leadIcon) : null,
        suffixIcon: widget.icon
            ? IconButton(
                icon: Icon(
                  obScure ? Icons.visibility_off : Icons.visibility,
                  color: isFieldActive ? AppColors.dividerLine : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    obScure = !obScure;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.dividerLine),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.dividerLine),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: widget.hintText,
        hintStyle: customFonts.copyWith(
          color: Colors.black,
          fontSize: 14,
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}

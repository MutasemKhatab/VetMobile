import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String labelText;
  final IconData icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  const CustomInputField({
    super.key,
    required this.labelText,
    required this.icon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.labelText == 'Password',
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        label: Text(widget.labelText),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(widget.icon),
        prefixIconColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

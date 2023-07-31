import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key,
      this.hintText,
      this.disabled,
      this.controller,
      this.keyboardType,
      this.maxLines,
      this.maxLength,
      this.expands,
      this.onChanged});

  final String? hintText;
  final bool? disabled;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final bool? expands;
  final ValueChanged? onChanged;

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        isDense: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MainTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool hideCharacters;
  final int? maxLines;
  final bool? enabled;
  final FormFieldValidator<String>? validator;
  const MainTextField({Key? key, this.hintText, this.controller, this.hideCharacters = false, this.validator, this.enabled, this.maxLines = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        enabled: enabled,
        maxLines: maxLines,
        controller: controller,
        validator: validator,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
        obscureText: hideCharacters,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.grey,
          fontSize: 12,)
        ),
      ),
    );
  }
}

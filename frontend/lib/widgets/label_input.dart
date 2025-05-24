import 'package:flutter/material.dart';

class LabelInput extends StatelessWidget {
  final String labelName;
  final bool isObscured;
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?) validator;
  final int maxLines;

  const LabelInput({
    required this.labelName,
    required this.controller,
    required this.validator,
    this.isObscured = false,
    this.maxLines = 1,
    this.hintText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labelName,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: maxLines,
                  controller: controller,
                  obscureText: isObscured,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: hintText,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(255, 211, 211, 211),
                          style: BorderStyle.solid),
                    ),
                  ),
                  validator: validator,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

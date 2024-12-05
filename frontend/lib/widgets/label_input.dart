import 'package:flutter/material.dart';

class LabelInput extends StatelessWidget {
  const LabelInput({
    required this.labelName,
    required this.controller,
    this.isObscured = false,
    this.hintText,
    super.key,
  });

  final String labelName;
  final bool isObscured;
  final TextEditingController controller;
  final String? hintText;

   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80, right: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded (
            child : Padding(
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
                        style: BorderStyle.solid
                      ),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Należy wypełnić pole';
                    }
                    return null;
                  },
                ),
                
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
}
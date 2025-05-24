import 'package:ale_okaz/consts/colors.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    required this.controller,
    required this.onChanged,
    super.key
  });

  final TextEditingController controller;
  final Function(String) onChanged; 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderDefault, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: SizedBox(
              height: 32,
              child: TextField(
                onChanged: onChanged, 
                controller: controller,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Szukaj',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

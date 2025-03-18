import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';

class MyDropdownMenu extends StatelessWidget {
  final Map<String,String> sortOptions;
  final Function onSortOptionChanged;
  final String currentSortOption;

  const MyDropdownMenu({
    required this.sortOptions,
    required this.currentSortOption,
    required this.onSortOptionChanged,
    super.key});



  @override
  Widget build(BuildContext context) {
    return Container(
              height: 30,
              decoration: BoxDecoration(border: Border.all(color: borderDefault, width: 1,),
              borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DropdownButton<String>(
                  value: currentSortOption,
                  style: const TextStyle(color: Colors.black,fontSize: 14),
                  itemHeight: 48,
                  menuWidth: 130,
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(8),
                  items: 
                    sortOptions.entries.map<DropdownMenuItem<String>>((entry) {
                      return DropdownMenuItem<String>(value: entry.key, child: Text(entry.value));
                    }).toList(),
                  onChanged: (String? newSortOption) {
                    if (newSortOption != null) {
                      onSortOptionChanged(newSortOption); // Notify the parent about the change
                    }
                  },
                ),
              ),
            );
  }
}
import 'package:flutter/material.dart';
import 'package:ale_okaz/consts/colors.dart';

class FriendContainer extends StatelessWidget {

  final String friendName;
  final Image? friendImage = null;
  final Map<String,String> friendOptions;
  final Function onSelected;

  const FriendContainer({
    required this.friendName,
    required this.onSelected,
    required this.friendOptions,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding:
              const EdgeInsets.only(left: 13, right: 13, top: 8, bottom: 8),
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: offWhiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 22),
                  Text(friendName,
                  style: const TextStyle(fontSize: 16),),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (String choice) {  
                  onSelected(choice);
                },
                icon: const Icon(Icons.more_horiz, color: tabGreenColor,),
                itemBuilder: 
                  (BuildContext context) => <PopupMenuEntry<String>> [
                    const PopupMenuItem(value: "profile", child:  Text('Profil')),
                    const PopupMenuItem(value:"delete", child: Text("Usuń")),

                  ],
              ),
            ],
          ),
        );
  }
}
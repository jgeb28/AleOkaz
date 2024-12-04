import 'package:flutter/material.dart';


class LineDivider extends StatelessWidget {
  const LineDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: Colors.black,  
              thickness: 1,         
              endIndent: 10,        
            ),
          ),
          Text(
            "lub",                  
            style: TextStyle(
              color: Colors.black,  
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.black,  
              thickness: 1,         
              indent: 10,           
            ),
          ),
        ],
      ),
    );
  }
}
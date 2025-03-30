import 'package:flutter/material.dart';

import 'package:ale_okaz/models/services/rest_service.dart';


class FishingSpotsTab extends StatefulWidget {
  const FishingSpotsTab({super.key});

  @override
  State<FishingSpotsTab> createState() => _FishingSpotsTabState();
}

class _FishingSpotsTabState extends State<FishingSpotsTab> {

  TextEditingController addController = TextEditingController();
  final RestService _restService = RestService();

   @override
  void dispose() {
    addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Inviting friends Placeholder'),
        TextField(
          controller: addController,
        ),
        OutlinedButton(onPressed: () async {
          String username = addController.text;
          await _restService.sendPOSTRequest(
            'http://10.0.2.2:8080/api/friends/add',
            {'username': username},
          );
        },
         child: Text('dodaj')),
      ],
    );
      
  }
}
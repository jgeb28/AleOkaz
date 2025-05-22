import 'package:ale_okaz/models/data/user.dart';
import 'package:ale_okaz/services/user_service.dart';
import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/utils/parser.dart';
import 'package:flutter/material.dart';

class PostTopBar extends StatefulWidget {
  final String userId;
  final String location;
  const PostTopBar({super.key, required this.userId, required this.location});

  @override
  State<PostTopBar> createState() => _PostTopBarState();
}

class _PostTopBarState extends State<PostTopBar> {
  late Future<User> _futureUser;
  final _urlParser = Parser();

  @override
  void initState() {
    super.initState();
    _futureUser = UserService().getUserInfo(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        _urlParser.getImageUrl(user.profilePictureUrl)),
                  ),
                  const SizedBox(width: 12),
                  // name + maybe timestamp
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(widget.location),
                      const SizedBox(width: 8),
                      const Icon(Icons.location_on,
                          color: buttonBackgroundColor)
                    ],
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {}

          return const CircularProgressIndicator();
        });
  }
}

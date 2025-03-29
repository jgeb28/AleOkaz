import 'package:ale_okaz/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    required this.isMyProfile,
    required this.username,
    super.key});

  final String? username;
  final bool isMyProfile;
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isEdited = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.username);
    _isEdited = false;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Container(
          height: 220,
          width: 220,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          height: 45,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: offWhiteColor,
          ),
          child: widget.isMyProfile ? Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: _isEdited ? TapRegion(
                  onTapOutside: (tap) {
                    setState(() {
                      _isEdited = false;
                    });
                  }
                  ,
                  child: TextField(
                      controller: _nameController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24),
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (newUsername) {
                          setState(() {
                            _isEdited = false;
                          });
                        },
                    ),
                )
                :
                Text(
                  widget.username ?? "Loading...",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                        _isEdited = !_isEdited;
                      });
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            ],
          ) :
          Text(
                  widget.username ?? "Loading...",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
        ),
        const SizedBox(
          height: 40,
        ),
        widget.isMyProfile ? FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 9, bottom: 9),
            backgroundColor: buttonBackgroundColor,
          ),
          child: const Text(
            'Udostępnij profil',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
            ),
          ),
        ) :
        IconButton(onPressed: (){}, icon: Icon(Icons.person_add_alt_rounded)),
      ],
    ));
  }
}

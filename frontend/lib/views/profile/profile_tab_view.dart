import 'package:ale_okaz/utils/colors.dart';
import 'package:ale_okaz/view_models/profile/profile_tab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTab extends StatefulWidget {
  final bool isMyProfile;
  final String? username;
  
  ProfileTab({required this.isMyProfile, required this.username, super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late ProfileTabViewModel viewModel;

  @override
  void initState() {
    Get.delete<ProfileTabViewModel>();
    viewModel = Get.put(ProfileTabViewModel());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ProfileTabViewModel>();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    viewModel.username.value = widget.username ?? "Loading...";

    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          height: 220,
          width: 220,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 40),
        
        Container(
          height: 45,
          width: double.infinity,
          decoration: const BoxDecoration(color: offWhiteColor),
          child: Obx(() {
            return widget.isMyProfile
                ? Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: viewModel.isEditing.value
                            ? TextField(
                                controller: TextEditingController(
                                    text: viewModel.username.value),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                                autofocus: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onSubmitted: viewModel.setUsername,
                              )
                            : Text(
                                viewModel.username.value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                              ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: viewModel.toggleEdit,
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  )
                : Text(
                    viewModel.username.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                  );
          }),
        ),
        
        const SizedBox(height: 40),
        
        widget.isMyProfile
            ? FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 9),
                  backgroundColor: buttonBackgroundColor,
                ),
                child: const Text(
                  'Udostępnij profil',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                ),
              )
            : IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_add_alt_rounded),
              ),
      ],
    );
  }
}

import 'package:ale_okaz/consts/colors.dart';
import 'package:ale_okaz/models/services/image_service.dart';
import 'package:ale_okaz/view_models/profile/profile_tab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTab extends StatefulWidget {
  final bool isMyProfile;
  final String? username;
  final String? profilePictureUrl;
  
  const ProfileTab({required this.isMyProfile, required this.username, required this.profilePictureUrl, super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late ProfileTabViewModel _viewModel;

  @override
  void initState() {
    Get.delete<ProfileTabViewModel>();
    _viewModel = Get.put(ProfileTabViewModel());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ImageController>();
    Get.delete<ProfileTabViewModel>();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _viewModel.username.value = widget.username ?? "Loading...";

    return Column(
      children: [
        const SizedBox(height: 40),
        Stack(
          children:  [
            widget.isMyProfile ? Obx(() => _viewModel.image.value == null
                ? Container(
                    width: 220.0,
                    height: 220.0,
                    decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image:  NetworkImage(widget.profilePictureUrl!))
                          )
                        )
                : Container(
                    width: 220.0,
                    height: 220.0,
                    decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image:  FileImage(_viewModel.image.value!))
                          )
                        )
                      )
                  : const SizedBox.shrink(),
            widget.isMyProfile ? Positioned(
              right: 0,
              bottom: 0,
              child: Obx(() => _viewModel.image.value == null ? Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: offWhiteColor,
                ),
                child: IconButton(
                  onPressed: () {
                    _viewModel.pickImage();
                  }, 
                  icon: const Icon(Icons.edit),),
              ):
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonBackgroundColor,
                ),
                child: IconButton(
                  onPressed: () {
                    _viewModel.setImage();
                    _viewModel.image.value = null;
                  }, 
                  icon: const Icon(Icons.check),
                  color: Colors.white,),
              )
              )): const SizedBox.shrink(),
      ]),
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
                        child: _viewModel.isEditing.value
                            ? TextField(
                                controller: TextEditingController(
                                    text: _viewModel.username.value),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                                autofocus: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onSubmitted: (value) {
                                  _viewModel.setUsername(value);
                                },
                              )
                            : Text(
                                _viewModel.username.value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                              ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: _viewModel.toggleEdit,
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  )
                : Center(
                  child: Text(
                      _viewModel.username.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                    ),
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

import 'dart:io';

import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/core/utils.dart';
import 'package:clonetwit/features/auth/controller/auth_controller.dart';
import 'package:clonetwit/features/user_profile/controller/user_profile_controller.dart';
import 'package:clonetwit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileVeiw extends ConsumerStatefulWidget {
  const EditProfileVeiw({super.key});
  static route() =>
      MaterialPageRoute(builder: (context) => const EditProfileVeiw());
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileVeiwState();
}

class _EditProfileVeiwState extends ConsumerState<EditProfileVeiw> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? bannerFile;
  File? profileFile;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.name ?? '',
    );
    bioController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.bio ?? '',
    );
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfilImage() async {
    final profile = await pickImage();
    if (profile != null) {
      setState(() {
        profileFile = profile;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Edit profile'),
        actions: [
          TextButton(
              onPressed: () {
                ref
                    .read(userProfileControllerProvider.notifier)
                    .updateUserProfile(
                        userModel: user!.copyWith(
                            bio: bioController.text, name: nameController.text),
                        context: context,
                        bannerFile: bannerFile,
                        profileFile: profileFile);
              },
              child: const Text('Save'))
        ],
      ),
      body: isLoading || user == null
          ? const Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(children: [
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        height: 150,
                        child: bannerFile != null
                            ? Image.file(
                                bannerFile!,
                                fit: BoxFit.fitWidth,
                              )
                            : user.bannerPic.isEmpty
                                ? Container(
                                    color: Pallete.blueColor,
                                  )
                                : Image.network(
                                    user.bannerPic,
                                    fit: BoxFit.fitWidth,
                                  ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: GestureDetector(
                        onTap: selectProfilImage,
                        child: profileFile != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(profileFile!),
                                radius: 40,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 40,
                              ),
                      ),
                    ),
                  ]),
                ),
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: 'name', contentPadding: EdgeInsets.all(18))),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                      hintText: 'bio', contentPadding: EdgeInsets.all(18)),
                  maxLines: 4,
                )
              ],
            ),
    );
  }
}

import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/features/auth/controller/auth_controller.dart';
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
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      body: user == null
          ? Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Stack(children: [
                  Container(
                      width: double.infinity,
                      child: user.bannerPic.isEmpty
                          ? Container(
                              color: Pallete.blueColor,
                            )
                          : Image.network(user.bannerPic)),
                  Positioned(
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 45,
                    ),
                  ),
                ]),
              ],
            ),
    );
  }
}

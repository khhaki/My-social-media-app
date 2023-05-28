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
    print(user?.bannerPic.isEmpty);
    return Scaffold(
      body: user == null
          ? const Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(children: [
                    user.bannerPic.isEmpty
                        ? Container(
                            width: double.infinity,
                            color: Pallete.blueColor,
                          )
                        : Image.network(user.bannerPic),
                    Positioned(
                      bottom: 0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 45,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
    );
  }
}

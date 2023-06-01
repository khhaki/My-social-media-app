// ignore_for_file: avoid_print

import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/constants/constants.dart';
import 'package:clonetwit/features/user_profile/controller/user_profile_controller.dart';
import 'package:clonetwit/features/user_profile/widget/user_profile.dart';
import 'package:clonetwit/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileview extends ConsumerWidget {
  final UserModel userModel;
  const UserProfileview({super.key, required this.userModel});
  static route(UserModel userModel) => MaterialPageRoute(
      builder: (context) => UserProfileview(
            userModel: userModel,
          ));
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfuser = userModel;
    print(
        '+++${(ref.watch(getLatestUserProfileDataProvider(copyOfuser.uid)).value)}+++++');
    return ref.watch(getLatestUserProfileDataProvider(copyOfuser.uid)).when(
        data: (newch) {
          print('entred');
          if (newch.events.contains(
            'databases.*.collections.${AppwriteConstants.usercollection}.documents.${copyOfuser.uid}.update',
          )) {
            copyOfuser = UserModel.fromMap(newch.payload);
          }
          return Scaffold(
            body: UserProfile(user: copyOfuser),
          );
        },
        error: (error, st) => ErrorText(error: error.toString()),
        loading: () {
          return Scaffold(
            body: UserProfile(user: copyOfuser),
          );
        });
  }
}

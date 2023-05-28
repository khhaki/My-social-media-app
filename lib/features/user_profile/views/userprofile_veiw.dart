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
    return Scaffold(
      body: UserProfile(user: userModel),
    );
  }
}

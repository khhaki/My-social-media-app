import 'package:clonetwit/features/user_profile/views/userprofile_veiw.dart';
import 'package:clonetwit/models/user_model.dart';
import 'package:clonetwit/theme/pallete.dart';
import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;
  const SearchTile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, UserProfileview.route(userModel));
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userModel.profilePic),
        radius: 30,
      ),
      title: Text(
        userModel.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.name}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            userModel.bio,
            style: TextStyle(fontSize: 16, color: Pallete.whiteColor),
          )
        ],
      ),
    );
  }
}

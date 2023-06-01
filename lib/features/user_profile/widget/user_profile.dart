// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/constants/constants.dart';
import 'package:clonetwit/features/auth/controller/auth_controller.dart';
import 'package:clonetwit/features/tweet/cotroller/tweet_controller.dart';
import 'package:clonetwit/features/tweet/widgets/tweet_card.dart';
import 'package:clonetwit/features/user_profile/controller/user_profile_controller.dart';
import 'package:clonetwit/features/user_profile/views/edit_profile_view.dart';
import 'package:clonetwit/features/user_profile/widget/follow_count.dart';
import 'package:clonetwit/models/tweet_model.dart';
import 'package:clonetwit/models/user_model.dart';
import 'package:clonetwit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(children: [
                    Positioned.fill(
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
                    Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                side: const BorderSide(
                                    width: 1.5, color: Pallete.whiteColor),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25)),
                            onPressed: () {
                              if (currentUser.uid == user.uid) {
                                Navigator.push(
                                    context, EditProfileVeiw.route());
                              }
                            },
                            child: Text(
                              currentUser.uid == user.uid
                                  ? 'Edit profile'
                                  : 'Follow',
                              style: const TextStyle(color: Pallete.whiteColor),
                            )))
                  ]),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    Text(
                      user.name,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@${user.name}',
                      style: const TextStyle(
                          fontSize: 17, color: Pallete.greyColor),
                    ),
                    Text(
                      user.bio,
                      style: const TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        FollowCount(
                            count: user.following.length, text: 'Following'),
                        const SizedBox(
                          width: 15,
                        ),
                        FollowCount(
                            count: user.followers.length, text: 'Followers')
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Divider(
                      color: Pallete.whiteColor,
                    )
                  ])),
                ),
              ];
            },
            body: ref.watch(getUserTweetsProvider(user.uid)).when(
                data: (tweets) {
                  return ref.watch(getLatestTweetProvider).when(
                      data: (data) {
                        final LatestTweet = Tweet.fromMap(data.payload);
                        bool chek = true;
                        for (var element in tweets) {
                          if (element.id == LatestTweet.id) {
                            chek = false;
                            break;
                          }
                        }
                        if (chek) {
                          if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetscollection}.documents.*.create')) {
                            tweets.insert(0, Tweet.fromMap(data.payload));
                          } else if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetscollection}.documents.*.update')) {
                            //get id for tweet
                            final startingindex =
                                data.events[0].lastIndexOf('documents.');

                            final endpoint =
                                data.events[0].lastIndexOf('.update');
                            final tweetid = data.events[0]
                                .substring(startingindex + 10, endpoint);
                            var tweet = Tweet.fromMap(data.payload);

                            tweet = tweets
                                .where((element) => element.id == tweetid)
                                .first;
                            final tweetindex = tweets.indexOf(tweet);
                            tweets.removeWhere(
                                (element) => element.id == tweetid);
                            tweet = Tweet.fromMap(data.payload);
                            tweets.insert(tweetindex, tweet);
                          }
                        }

                        return ListView.builder(
                            itemCount: tweets.length,
                            itemBuilder: (BuildContext context, int index) {
                              final tweet = tweets[index];
                              return TweetCard(tweet: tweet);
                            });
                      },
                      error: (error, StackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () {
                        return ListView.builder(
                            itemCount: tweets.length,
                            itemBuilder: (BuildContext context, int index) {
                              final tweet = tweets[index];
                              return TweetCard(tweet: tweet);
                            });
                      });
                },
                error: (error, st) => ErrorText(error: error.toString()),
                loading: () => const Loader()));
  }
}

import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/constants/appwrite_constants.dart';
import 'package:clonetwit/features/tweet/cotroller/tweet_controller.dart';
import 'package:clonetwit/features/tweet/widgets/tweet_card.dart';
import 'package:clonetwit/models/tweet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
        data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
              data: (data) {
                if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetscollection}.documents.*.create')) {
                  tweets.insert(0, Tweet.fromMap(data.payload));
                }
                return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    });
              },
              error: (error, StackTrace) => ErrorText(error: error.toString()),
              loading: () {
                return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    });
              });
        },
        error: (error, StackTrace) => ErrorText(error: error.toString()),
        loading: () => Loader());
  }
}

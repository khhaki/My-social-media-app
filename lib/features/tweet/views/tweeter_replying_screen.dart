import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/constants/constants.dart';
import 'package:clonetwit/features/tweet/cotroller/tweet_controller.dart';
import 'package:clonetwit/features/tweet/widgets/tweet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clonetwit/models/tweet_model.dart';

class TweeterReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
      builder: (context) => TweeterReplyScreen(
            tweet: tweet,
          ));
  final Tweet tweet;
  const TweeterReplyScreen({
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tweet'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetProvider(tweet)).when(
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
                      if (LatestTweet.repliedto == tweet.id && chek) {
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
                          print(tweetid);
                          var tweet = Tweet.fromMap(data.payload);

                          tweet = tweets
                              .where((element) => element.id == tweetid)
                              .first;
                          final tweetindex = tweets.indexOf(tweet);
                          tweets
                              .removeWhere((element) => element.id == tweetid);
                          tweet = Tweet.fromMap(data.payload);
                          tweets.insert(tweetindex, tweet);
                        }
                      }

                      return Expanded(
                        child: ListView.builder(
                            itemCount: tweets.length,
                            itemBuilder: (BuildContext context, int index) {
                              final tweet = tweets[index];
                              return TweetCard(tweet: tweet);
                            }),
                      );
                    },
                    error: (error, StackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: tweets.length,
                            itemBuilder: (BuildContext context, int index) {
                              final tweet = tweets[index];
                              return TweetCard(tweet: tweet);
                            }),
                      );
                    });
              },
              error: (error, StackTrace) => ErrorText(error: error.toString()),
              loading: () => Loader()),
        ],
      ),
      bottomNavigationBar: TextField(
        decoration: const InputDecoration(
          hintText: 'tweet your reply',
        ),
        onSubmitted: (value) {
          ref.read(tweetControllerProvider.notifier).shareTweet(
              images: [], text: value, context: context, repliedto: tweet.id);
        },
      ),
    );
  }
}

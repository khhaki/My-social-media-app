// ignore_for_file: unused_import, depend_on_referenced_packages

import 'dart:io';

import 'package:clonetwit/apis/storage_api.dart';
import 'package:clonetwit/apis/tweet_api.dart';
import 'package:clonetwit/core/enums/tweet_type_enum.dart';
import 'package:clonetwit/core/utils.dart';
import 'package:clonetwit/features/auth/controller/auth_controller.dart';
import 'package:clonetwit/models/tweet_model.dart';
import 'package:clonetwit/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
      ref: ref,
      tweetAPI: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(storageAPIProvider));
});
final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getLatestTweetProvider = StreamProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});
final getRepliesToTweetProvider = FutureProvider.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});

final getTweetByIdProvider = FutureProvider.family((ref, String id) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  TweetController(
      {required Ref ref,
      required TweetAPI tweetAPI,
      required StorageAPI storageAPI})
      : _storageAPI = storageAPI,
        _ref = ref,
        _tweetAPI = tweetAPI,
        super(false);
  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetAPI.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }

  Future<void> likeTweet(Tweet tweet, UserModel user) async {
    List<String> likes = tweet.likes;
    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }
    //update the field
    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetAPI.likeTweet(tweet);
    res.fold((l) => null, (r) => null);
  }

  Future<void> reschareTweet(
      Tweet tweet, UserModel currentuser, BuildContext context) async {
    tweet = tweet.copyWith(
        retweetedBy: currentuser.name,
        likes: [],
        commentsIds: [],
        reshareCount: tweet.reshareCount + 1);
    final res = await _tweetAPI.updateReshareCount(tweet);

    res.fold((l) => showSnakBar(context, l.message), (r) async {
      tweet = tweet.copyWith(
          id: ID.unique(), reshareCount: 0, tweeteddAt: DateTime.now());
      final res2 = await _tweetAPI.shareTweet(tweet);
      res2.fold((l) => showSnakBar(context, l.message),
          (r) => showSnakBar(context, "Retweeted"));
    });
  }

  void shareTweet(
      {required List<File> images,
      required String text,
      required String repliedto,
      required BuildContext context}) {
    if (text.isEmpty) {
      showSnakBar(context, "please enter text");
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(
          images: images, text: text, context: context, repliedto: repliedto);
    } else {
      _shareTextTweet(text: text, context: context, repliedto: repliedto);
    }
  }

  Future<void> _shareImageTweet(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedto}) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value;
    final imageLinks = await _storageAPI.upLoadImages(images);
    Tweet tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: imageLinks,
        uid: user!.uid,
        tweetType: TweetType.image,
        tweeteddAt: DateTime.now(),
        likes: const [],
        commentsIds: const [],
        id: '',
        reshareCount: 0,
        retweetedBy: '',
        repliedto: repliedto);
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnakBar(context, l.message), (r) => null);
  }

  Future<void> _shareTextTweet(
      {required String text,
      required BuildContext context,
      required String repliedto}) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value;
    Tweet tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: const [],
        uid: user!.uid,
        tweetType: TweetType.text,
        tweeteddAt: DateTime.now(),
        likes: const [],
        commentsIds: const [],
        id: '',
        reshareCount: 0,
        retweetedBy: '',
        repliedto: repliedto);
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnakBar(context, l.message), (r) => null);
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final document = await _tweetAPI.getRepliesToTweet(tweet);
    return document.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }
}

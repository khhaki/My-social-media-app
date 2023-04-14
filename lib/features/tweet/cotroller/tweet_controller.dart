import 'dart:io';

import 'package:clonetwit/apis/storage_api.dart';
import 'package:clonetwit/apis/tweet_api.dart';
import 'package:clonetwit/core/enums/tweet_type_enum.dart';
import 'package:clonetwit/core/utils.dart';
import 'package:clonetwit/features/auth/controller/auth_controller.dart';
import 'package:clonetwit/models/tweet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void shareTweet(
      {required List<File> images,
      required String text,
      required BuildContext context}) {
    if (text.isEmpty) {
      showSnakBar(context, "please enter text");
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(images: images, text: text, context: context);
    } else {
      _shareTextTweet(text: text, context: context);
    }
  }

  Future<void> _shareImageTweet(
      {required List<File> images,
      required String text,
      required BuildContext context}) async {
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
        reshareCount: 0);
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnakBar(context, l.message), (r) => null);
  }

  Future<void> _shareTextTweet(
      {required String text, required BuildContext context}) async {
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
        reshareCount: 0);
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
}

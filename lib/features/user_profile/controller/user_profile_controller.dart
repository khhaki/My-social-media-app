import 'dart:io';

import 'package:clonetwit/apis/storage_api.dart';
import 'package:clonetwit/apis/tweet_api.dart';
import 'package:clonetwit/apis/user_api.dart';
import 'package:clonetwit/core/utils.dart';

import 'package:clonetwit/models/tweet_model.dart';
import 'package:clonetwit/models/user_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
      tweetAPI: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(storageAPIProvider),
      userAPI: ref.watch(userAPIProvider));
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(uid);
});

final getLatestUserProfileDataProvider =
    StreamProvider.family.autoDispose((ref, String uid) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  UserProfileController(
      {required TweetAPI tweetAPI,
      required StorageAPI storageAPI,
      required UserAPI userAPI})
      : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        super(false);
  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  Future<void> updateUserProfile(
      {required UserModel userModel,
      required BuildContext context,
      required File? bannerFile,
      required File? profileFile}) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.upLoadImages([bannerFile]);
      userModel = userModel.copyWith(bannerPic: bannerUrl[0]);
    }

    if (profileFile != null) {
      final profileUrl = await _storageAPI.upLoadImages([profileFile]);
      userModel = userModel.copyWith(profilePic: profileUrl[0]);
    }
    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold((l) => showSnakBar(context, l.message), (r) => null);
  }
}

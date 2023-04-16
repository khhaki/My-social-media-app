import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:clonetwit/constants/appwrite_constants.dart';

import 'package:clonetwit/core/core.dart';
import 'package:clonetwit/core/provider.dart';
import 'package:clonetwit/models/tweet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(
      db: ref.watch(appwriteDataBaseProvider),
      realtime: ref.watch(appwriteRealtimeProvider));
});

abstract class ITweetAPI {
  FutureEtheir<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEtheir<Document> likeTweet(Tweet tweet);
  FutureEtheir<Document> updateReshareCount(Tweet tweet);
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;
  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEtheir<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetscollection,
          documentId: ID.unique(),
          data: tweet.toMap());
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'some unexpected error occured', st),
      );
    } catch (e, st) {
      return left(
        Failure(e.toString(), st),
      );
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final document = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetscollection,
        queries: [Query.orderDesc('tweeteddAt')]);
    return document.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetscollection}.documents'
    ]).stream;
  }

  @override
  FutureEtheir<Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetscollection,
          documentId: tweet.id,
          data: {'likes': tweet.likes});
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'some unexpected error occured', st),
      );
    } catch (e, st) {
      return left(
        Failure(e.toString(), st),
      );
    }
  }

  @override
  FutureEtheir<Document> updateReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetscollection,
          documentId: tweet.id,
          data: {'reshareCount': tweet.reshareCount});
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'some unexpected error occured', st),
      );
    } catch (e, st) {
      return left(
        Failure(e.toString(), st),
      );
    }
  }
}

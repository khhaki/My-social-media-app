// ignore_for_file: depend_on_referenced_packages

import 'package:appwrite/appwrite.dart';
import 'package:clonetwit/constants/constants.dart';
import 'package:clonetwit/core/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:appwrite/models.dart' as model;

import '../core/core.dart';
import '../models/user_model.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
      db: ref.watch(appwriteDataBaseProvider),
      realtimeu: ref.watch(appwriteRealtimeProvider));
});

abstract class IUserAPI {
  FutureEtheirVoid saveUserData(UserModel user);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> searchUserByName(String name);
  FutureEtheirVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData(String uid);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtimeu;
  UserAPI({required Databases db, required Realtime realtimeu})
      : _db = db,
        _realtimeu = realtimeu;
  @override
  FutureEtheirVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usercollection,
          documentId: userModel.uid,
          data: userModel.toMap());
      return right(null);
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
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usercollection,
        documentId: uid);
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usercollection,
      queries: [Query.search('name', name)],
    );
    return documents.documents;
  }

  @override
  FutureEtheirVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usercollection,
          documentId: userModel.uid,
          data: userModel.toMap());
      return right(null);
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
  Stream<RealtimeMessage> getLatestUserProfileData(String uid) {
    return _realtimeu.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usercollection}.documents.$uid'
    ]).stream;
  }
}

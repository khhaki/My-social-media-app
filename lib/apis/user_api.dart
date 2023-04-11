import 'package:appwrite/appwrite.dart';
import 'package:clonetwit/constants/constants.dart';
import 'package:fpdart/fpdart.dart';

import '../core/core.dart';
import '../models/user_model.dart';

abstract class IUserAPI {
  FutureEtheirVoid saveUserData(UserModel user);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  UserAPI({required Databases db}) : _db = db;
  @override
  FutureEtheirVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usercollection,
          documentId: ID.unique(),
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
}

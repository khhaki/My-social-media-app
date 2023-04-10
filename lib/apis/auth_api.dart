// ignore_for_file: depend_on_referenced_packages

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart ' as model;
import 'package:clonetwit/core/provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';
import '../core/core.dart';

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account);
});

// want to signup, want to get user account-> Account
// want to acces user related data-> model.Account
abstract class IAuthAPI {
  //if succes return string, if failure return Account
  FutureEtheir<model.Account> signUp({
    required String email,
    required String password,
  });

  FutureEtheir<model.Session> logIn({
    required String email,
    required String password,
  });
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({
    required Account account,
  }) : _account = account;
  @override
  FutureEtheir<model.Account> signUp(
      {required String email, required String password}) async {
    try {
      final account = await _account.create(
          userId: ID.unique(), email: email, password: password);
      return right(account as model.Account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEtheir<model.Session> logIn(
      {required String email, required String password}) async {
    try {
      final session =
          await _account.createEmailSession(email: email, password: password);
      return right(session as model.Session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}

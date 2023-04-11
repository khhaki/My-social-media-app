// ignore_for_file: depend_on_referenced_packages

import 'package:clonetwit/apis/auth_api.dart';
import 'package:clonetwit/apis/user_api.dart';
import 'package:clonetwit/core/utils.dart';
import 'package:clonetwit/features/home/view/home_view.dart';
import 'package:clonetwit/features/auth/view/login_view.dart';
import 'package:clonetwit/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as model;

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authAPI: ref.watch(authAPIProvider),
      userAPI:
          ref.watch(userAPIProvider as AlwaysAliveProviderListenable<UserAPI>));
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  //isLoading
//account.get!=null? Homescreen:loginscreen;
  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold((l) => showSnakBar(context, l.message), (r) async {
      UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: [],
          following: [],
          profilePic: '',
          bannerPic: '',
          uid: '',
          bio: '',
          isTwblue: false);
      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) => showSnakBar(context, l.message), (r) {
        showSnakBar(context, 'Account created please login');
        Navigator.push(context, LoginView.route());
      });
    });
  }

  void logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.logIn(email: email, password: password);
    res.fold((l) => showSnakBar(context, l.message), (r) {
      Navigator.push(context, HomeView.route());
    });
  }
}

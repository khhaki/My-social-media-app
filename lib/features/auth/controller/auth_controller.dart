import 'package:clonetwit/apis/auth_api.dart';
import 'package:clonetwit/core/utils.dart';
import 'package:clonetwit/features/home/view/home_view.dart';
import 'package:clonetwit/features/auth/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as model;

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authAPI: ref.watch(authAPIProvider));
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);

  //isLoading
//account.get!=null? Homescreen:loginscreen;
  Future currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    res.fold((l) => showSnakBar(context, l.message), (r) {
      showSnakBar(context, 'Account created please login');
      Navigator.push(context, LoginView.route());
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

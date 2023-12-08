import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/authapi.dart';
import 'package:twitter_clone/features/auth/view/login_page.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';

import '../../../core/core.dart';

final authControllerProvider = StateNotifierProvider<AuthController,bool>((ref) {
  return AuthController(authAPI: ref.watch(authAPIProvider));
});

final currentUserProvider = FutureProvider((ref) async {
  final authcontroller = ref.watch(authControllerProvider.notifier);
  return authcontroller.currentUserAccount();
});


class AuthController extends  StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authAPI}):_authAPI = authAPI,super(false);

  Future<models.User?> currentUserAccount() => _authAPI.currentUserAccount();

  void signUp({
    required String email, 
    required String password,
    required BuildContext context,
    }) async {
    state = true;
      final res = await _authAPI.signUp(email: email, password: password);
      state = false;
      res.fold((l) => showSnackBar(context,l.message),
       (r) {
        showSnackBar(context, "Account Created! Please Login");
        Navigator.push(context, LoginPage.route());
        });
  }
  void logIn({
    required String email,
    required String password,
    required BuildContext context,
  })async{
    final res = await _authAPI.logIn(email: email, password: password);
    return res.fold((l) => null,
    (r) {
      Navigator.push(context, HomeView.route());
    }
    );
  }
}
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/authapi.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/features/auth/view/login_page.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';

import '../../../core/core.dart';
import '../../../models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController,bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider)
    );
});

final currentUserDetailProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
   return userDetails.value;
});
final userDetailsProvider = FutureProvider.family((ref,String uid) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
 final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUserAccount();
});




class AuthController extends  StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })
  :_authAPI = authAPI,
  _userAPI = userAPI,
  super(false);

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
       (r)async {
        UserModel userModel = UserModel(email: email,
         name: getNameFromEmail(email),
          followers: [],
           follwing: [],
            profilePic: "",
             bannerPic: "",
              uid: r.$id,
               bio: "",
                isTwitterblue: false);
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold(
          (l) => showSnackBar(context,l.message), 
        (r) {showSnackBar(context, "Account Created! Please Login");
        Navigator.push(context, LoginPage.route()
        );
        });
        
        });
  }
  void logIn({
    required String email,
    required String password,
    required BuildContext context,
  })async{
    final res = await _authAPI.logIn(email: email, password: password);
    return res.fold((l) => showSnackBar(context,l.message),
    (r) {
      Navigator.push(context, HomeView.route());
    }
    );
  }

  Future<UserModel> getUserData(String uid) async {
    final document =  await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}
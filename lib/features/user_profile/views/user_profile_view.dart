import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/erorr_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/user_profile/contoller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/widgets/user_profile.dart';
import 'package:twitter_clone/models/user_model.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => 
  MaterialPageRoute(builder: (context) => 
  UserProfileView(userModel: userModel)
  );
  final UserModel userModel;
  const UserProfileView({
    super.key,
    required this.userModel
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = userModel;
    return Scaffold(
      body: ref.watch(
        getLatestUserPrifileDataProvider).when(
        data: (data){
          if(data.events.contains(
            'databases.*.collections.${AppwriteConstants.usersCollection}.documents.${copyOfUser.uid}.update'
            )){
              copyOfUser = UserModel.fromMap(data.payload);
            }
         return UserProfile(user: copyOfUser);
        },
        error: (error,st){
          return ErorrText(erorrtext: error.toString());
        },
        loading: () {
          return UserProfile(user: copyOfUser);
        },
        ) 
    );
  }
}
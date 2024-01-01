import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

final userProfileControllerProvider = StateNotifierProvider<UserProfileController,bool>((ref) {
  return UserProfileController(
    tweeAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider)
    ) ;
});

final getUserTweetsProvider = FutureProvider.family((ref,String uid) {
  final userProfileController =  ref.watch(userProfileControllerProvider.notifier);
  return  userProfileController.getUserTweets(uid);
});

class UserProfileController extends StateNotifier <bool>{
  final TweeAPI _tweeAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  UserProfileController({
    required TweeAPI tweeAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI
  })
  :_tweeAPI = tweeAPI,
  _storageAPI = storageAPI,
  _userAPI = userAPI, 
  super(false);

  Future<List<Tweet>> getUserTweets(String uid)async{
    final tweets = await _tweeAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  })async{
    state = true;
    if(bannerFile != null){
      final bannerUrl = await _storageAPI.uploadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }
    if(profileFile != null){
      final profileUrl = await _storageAPI.uploadImage([profileFile]);
      userModel = userModel.copyWith(
        bannerPic: profileUrl[0],
      );
    }
    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold((l) => showSnackBar(context,l.message), 
    (r) => Navigator.pop(context)
    );
  }
  
}
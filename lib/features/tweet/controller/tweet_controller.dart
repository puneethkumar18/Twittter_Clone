import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/authapi_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';


final tweetControllerProvider = StateNotifierProvider<TweetController,bool>((ref) {
  return TweetController(
    ref: ref, 
    tweeAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider)
    );
});

final getTweetsProvider = FutureProvider.autoDispose((ref) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getReapliesToTweetsProvider = FutureProvider.family((ref,Tweet tweet) async {
  final tweetcontroller = ref.watch(tweetControllerProvider.notifier);
  return tweetcontroller.getRepliesToTweet(tweet);
});

final getLatestTweetProvider = StreamProvider.autoDispose((ref) {
  final tweeAPI = ref.watch(tweetAPIProvider);
  return tweeAPI.getLatestTweet();
});

final getTweetByIdProvider = FutureProvider.family((ref,String id) async {
  final tweetcontroller = ref.watch(tweetControllerProvider.notifier);
  return tweetcontroller.getTweetById(id);
});

class TweetController extends StateNotifier<bool> {
  final TweeAPI _tweeAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;

  TweetController({
    required Ref ref,
    required TweeAPI tweeAPI,
    required StorageAPI storageAPI
    })
    :_ref = ref, 
    _storageAPI =storageAPI,
    _tweeAPI = tweeAPI,
    super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweeAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetById(String id)async{
    final tweet = await _tweeAPI.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }

  void reshareTweet(
    Tweet tweet,
    UserModel currentuser,
    BuildContext context,
  )async{
    tweet = tweet.copyWith(
      retweetedBy: currentuser.name,
      likes: [],
      commentIds: [],
      reshareCount: tweet.reshareCount+1,
    );
    
    final res = await _tweeAPI.updateReshareCount(tweet);
    res.fold((l) => showSnackBar(context,l.message),
    (r) async {
       tweet = tweet.copyWith(
          id: ID.unique(),
          reshareCount: 0,
          retweetedBy: currentuser.name,
          likes: [],
          commentIds: [],
          tweetedAt: DateTime.now(),
       );
        final  res2 = await _tweeAPI.shareTweet(tweet);
        res2.fold((l) => showSnackBar(context,l.message), 
        (r) => showSnackBar(context, "Retweeted")
        );
    });
  }

  void likeTweet(Tweet tweet,UserModel user) async{
    List<String> likes = tweet.likes;
    if(tweet.likes.contains(user.uid)){
      likes.remove(user.uid);
    }else{
      likes.add(user.uid);
    }

    tweet = tweet.copyWith(likes: likes);
    final res = await _tweeAPI.likeTweet(tweet);
    res.fold((l) => null, (r) => null);
  }
  
  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context ,
    required String repliedTo,
    }){
      if(text.isEmpty){
        showSnackBar(context, "Please enter some text");
        return;
      }
      if(images.isEmpty){
        _shareTextTweet(
          text: text, 
          context: context, 
          repliedTo: repliedTo
          );
      }else{
        _shareImageTweet(
          images: images, 
          text: text, 
          context: context, 
          repliedTo: repliedTo
          );
      }
      
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet)async{
    final documents = await _tweeAPI.getRepliesToTweet(tweet);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }
  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context  ,
    required String repliedTo,   
  }) async {
    state  = true;
    final hashtags = _getHashTagsFromText(text);
    final link  = _getLinkFromText(text: text);
    final imagesLinks = await _storageAPI.uploadImage(images);

    final user = _ref.watch(currentUserDetailProvider).value!;
    Tweet tweet = Tweet(
      text: text, 
      hashtags: hashtags, 
      link: link, 
      imageLinks: imagesLinks, 
      uid: user.uid, 
      tweetType: TweetType.image, 
      tweetedAt: DateTime.now(), 
      commentIds: const [], 
      likes: const [], 
      id: ID.unique(), 
      reshareCount: 0, 
      retweetedBy: '',
      repliedTo: '',
      );
      
      final res = await _tweeAPI.shareTweet(tweet);
      state = false;
      res.fold((l) => showSnackBar(context,l.message), (r) => null);
  }
  void _shareTextTweet({
    required String text,
    required BuildContext context ,
    required String repliedTo,
  }) async {
    state = true;
    final hashtags = _getHashTagsFromText(text);
    final link = _getLinkFromText(text: text);
    final user = _ref.read(currentUserDetailProvider).value!;
    Tweet tweet = Tweet(
      text: text, 
      hashtags: hashtags, 
      link: link, 
      imageLinks: const [], 
      uid: user.uid, 
      tweetType: TweetType.text, 
      tweetedAt: DateTime.now(), 
      commentIds: const [], 
      likes: const [], 
      id: '', 
      reshareCount: 0, 
      retweetedBy: '',
      repliedTo: '',
      );
     final res = await _tweeAPI.shareTweet(tweet);
     state = false;
     res.fold((l) => showSnackBar(context,l.message), (r) => null);
    
  }

  String _getLinkFromText({required String text}){
    List<String> wordsInSetences = text.split(' ');
    String link = '';
    for(String word in wordsInSetences){
      if(word.startsWith("https://") || word.startsWith('www.')){
        link = word;
      }
    }
    return link;
  }
  List<String> _getHashTagsFromText(String text){
    List<String> wordsInSetences = text.split(' ');
    List<String> hashTags = [];
    for(String  word in wordsInSetences){
      if(word.startsWith('#')){
        hashTags.add(word);
      }
    }
    return hashTags;
  }

  
}
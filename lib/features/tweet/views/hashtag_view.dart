import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';

import '../../../common/erorr_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../models/tweet_model.dart';
import '../widgets/tweet_card.dart';

class HashtagView extends ConsumerWidget {
  static route(String hashTag) => 
  MaterialPageRoute(
    builder: (context) => 
  HashtagView(hashTag: hashTag)
  );
  final String hashTag;
  const HashtagView({
    required this.hashTag,
    super.key
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(hashTag),
        ),
        body: ref.watch(getTweetsByHashtagProvider(hashTag)).
    when(
      data: (tweets){
        return ref.watch(getLatestTweetProvider).when(
          data: (data){
            if(data.events.contains(
              'databases.*.${AppwriteConstants.databaseId}.collections.*.${AppwriteConstants.tweetCollection}.documents.*.create'
            )){
              for(final tag in Tweet.fromMap(data.payload).hashtags){
                if(tag == hashTag ){
                  tweets.insert(0, Tweet.fromMap(data.payload));
                }
              }
            }
            return ListView.builder(
          itemCount: tweets.length,
          itemBuilder: (BuildContext context ,int index){
            final tweet = tweets[index];
            return TweetCard(tweet: tweet,);
        });   
        },
         error: (error,st) => ErorrText(erorrtext: error.toString()), 
         loading: (){
            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: 
              (BuildContext context ,int index){
                final tweet = tweets[index];
                return TweetCard(tweet: tweet,);
            });

         }
        );
  },
         
          error: (e,st) => ErorrText(erorrtext: e.toString()), 
        loading: ()=> const Loader(),
      
      ),
    );
    
  }
}
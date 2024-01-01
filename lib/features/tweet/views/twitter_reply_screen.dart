
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/erorr_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/models/tweet_model.dart';

import '../../../constants/appwrite_constants.dart';


class TwitterReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
    builder: (context) => TwitterReplyScreen(tweet: tweet)
    );
  final Tweet tweet;
  const TwitterReplyScreen({super.key,required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const  Text("Tweet"),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getReapliesToTweetsProvider(tweet)).
    when(
      data: (tweets){
        return ref.watch(getLatestTweetProvider).
        when(
          data: (data){
            final latestTweet = Tweet.fromMap(data.payload);

            bool isTweetAlreadyPresent = false;
            for(final tweetModel in tweets){
                if(tweetModel.id == latestTweet.id){
                  isTweetAlreadyPresent = true;
                  break;
                }
            }
            if( !isTweetAlreadyPresent && latestTweet.id == tweet.id){
              if(data.events.contains(
              'databases.*.${AppwriteConstants.databaseId}.collections.*.${AppwriteConstants.tweetCollection}.documents.*.create'
            )){
              tweets.insert(0, Tweet.fromMap(data.payload));
            }else if(data.events.contains(
              'databases.*.${AppwriteConstants.databaseId}.collections.*.${AppwriteConstants.tweetCollection}.documents.*.create'
            )){

              final startingPoint = data.events[0].lastIndexOf("documents.");
              final endinPoint = data.events[0].lastIndexOf('.update');
              final tweetId = data.events[0].substring(startingPoint + 10, endinPoint);

              var tweet = tweets.where((element) => element.id == tweetId)
              .first;

              final tweetIndex = tweets.indexOf(tweet); 
              tweets.removeWhere((element) => element.id == tweetId);

              tweet = Tweet.fromMap(data.payload);
              tweets.insert(tweetIndex, tweet);
            }
            }
            
            return Expanded(
              child: ListView.builder(
                        itemCount: tweets.length,
                        itemBuilder: (BuildContext context ,int index){
              final tweet = tweets[index];
              return TweetCard(tweet: tweet,);
                      }),
            );
          }, 
          error: (e,st){
            return ErorrText(erorrtext: e.toString());
            }, 
            loading: () {
              return Expanded(
                child: ListView.builder(
                          itemCount: tweets.length,
                          itemBuilder: (BuildContext context ,int index){
                            final tweet = tweets[index];
                            return TweetCard(tweet: tweet,);
                          }),
              );
            },
            );
      },
      error: (e,st) => ErorrText(erorrtext: e.toString()), 
      loading: ()=> const Loader(),
      ),
  
      ],
      ),
      bottomNavigationBar:  TextField(
        onSubmitted: (value) {
              ref.read(tweetControllerProvider.notifier).
              shareTweet(
                images: [], 
                text: value, 
                context: context,
                repliedTo: tweet.id,
                );
        },
        decoration: const InputDecoration(
          hintText: "Tweet your reply",
        ),
      ),
    );
  }
}
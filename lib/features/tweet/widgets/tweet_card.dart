import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/authapi_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/views/twitter_reply_screen.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:get_time_ago/get_time_ago.dart' as timeago;


class TweetCard extends ConsumerWidget {
  final Tweet tweet;

  const TweetCard({
    super.key,
    required this.tweet
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentuser = ref.watch(currentUserDetailProvider).value;
    return currentuser == null ? const SizedBox() : ref.watch(userDetailsProvider(tweet.uid)).when(
      data: (user){
       return   GestureDetector(
         onTap: (){
          Navigator.push(context, TwitterReplyScreen.route(tweet));
         },
         child: Column(
               children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                  radius: 30,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(tweet.retweetedBy.isNotEmpty)
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetsConstants.retweetIcon,                      
                          // ignore: deprecated_member_use
                          color: Pallete.greyColor,
                          height: 20,
                          ),
                          const SizedBox(width: 2,),
                          Text('${tweet.retweetedBy} has retweered',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),)
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19
                            ),
                          ),
                        ),
                        Text(
                            '@${user.name}. ${
                              timeago.GetTimeAgo.parse(
                              tweet.tweetedAt,
                              locale: 'en_shorts'
                            )}',
                            style: const  TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Pallete.greyColor
                            ),
                          ),
                      ],
                    ),
                    //reaplied to 
                    if(tweet.repliedTo.isNotEmpty)
                    ref.watch(getTweetByIdProvider(tweet.repliedTo))
                    .when(
                      data:(repliedToTweet) {
                        final replyingToUser = 
                           ref.watch(userDetailsProvider(repliedToTweet.uid)).value;
                     return RichText(text:  TextSpan(
                      text: "Replying to",
                      style: const TextStyle(
                        color: Pallete.greyColor,
                        fontSize: 16,
                      ),
                      children: [
                         TextSpan(
                      text: "@${replyingToUser?.name}",
                      style: const TextStyle(
                        color: Pallete.blueColor,
                        fontSize: 16,
                      ),
                    ),
                      ]
                    ),
                    );
                   } ,
                 error: (error,st) => ErorrText(
                  erorrtext: error.toString()),
                 loading: () => const SizedBox(),
                  ),
                    HashtagText(text: tweet.text),
                    if(tweet.tweetType == TweetType.image)
                        CarouselImage(imageLinks: tweet.imageLinks),
                    if(tweet.link.isNotEmpty) ...[
                      const SizedBox(height: 4,),
                      AnyLinkPreview(
                        displayDirection: 
                        UIDirection.uiDirectionHorizontal,
                        link: 'https://${tweet.link}'
                        ),
                    ],
                    Container(
                      margin: const EdgeInsets.only(top: 10,right: 20),
                      child: Row(
                        children: [
                          TweetIconButton(
                            pathName: AssetsConstants.viewsIcon, 
                            text: (tweet.commentIds.length + tweet.reshareCount + tweet.likes.length).toString(), 
                            onTap: (){}
                            ),
                          TweetIconButton(pathName: AssetsConstants.commentIcon, 
                          text: (tweet.commentIds.length).toString(), 
                          onTap: (){}
                          ),
                          TweetIconButton(pathName: AssetsConstants.retweetIcon, 
                          text: (tweet.reshareCount).toString(), 
                          onTap: (){
                            ref.read(tweetControllerProvider.notifier).reshareTweet(
                              tweet, currentuser, context
                              );
                          } ,
                          ),
                          LikeButton(
                            size: 25,
                            onTap: (isLiked)async{
                              ref.read(tweetControllerProvider.notifier).
                              likeTweet(tweet, currentuser);
                              return !isLiked;
                            },
                            isLiked: 
                                  tweet.likes.contains(currentuser.uid),
                            likeBuilder: (isLiked){
                              return isLiked ?
                              SvgPicture.asset(
                                AssetsConstants.likeFilledIcon,
                                // ignore: deprecated_member_use
                                color: Pallete.redColor,
                                )
                            :
                              SvgPicture.asset(
                                AssetsConstants.likeOutlinedIcon,
                                // ignore: deprecated_member_use
                                color: Pallete.greyColor,
                                );
                            },
                            likeCount: tweet.likes.length,
                            countBuilder: (likeCount, isLiked, text) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    color : isLiked 
                                    ? Pallete.redColor 
                                    : Pallete.whiteColor,
                                    fontSize: 16,
                                  ),
                                  ),
                              );
                            },
                          ),
                        
                          IconButton(
                            onPressed: (){}, 
                            icon: const Icon(
                              Icons.share_outlined,
                              size:25,
                              ),
                          ),     
                        ],
                      ),
                    ),
                    const SizedBox(height: 1,)
                  ],
                ),
              )
            ],
          ),
          const Divider(color: Pallete.greyColor,)
               ],
             ),
       );
      }, 
      error: (error,st) => ErorrText(erorrtext: error.toString()), 
      loading: () =>const Loader(),
      );
  }
}
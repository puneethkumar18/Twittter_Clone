
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/explore/view/explore_view.dart';
import 'package:twitter_clone/features/notifications/view/notifications_view.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_list.dart';
import 'package:twitter_clone/theme/theme.dart';


class UIConstants{
  static AppBar appBar = AppBar(
    title: SvgPicture.asset(AssetsConstants.twitterLogo
    ,
    // ignore: deprecated_member_use
    color: Pallete.blueColor,
    height: 30,
    ),
      );

    static const List<Widget> bottomTapBarPages  = [
      TweetList(),
      ExploreView(),
      NotificationView(),
    ];
}
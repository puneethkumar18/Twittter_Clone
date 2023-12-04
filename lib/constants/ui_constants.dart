import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/theme/pallete.dart';

class UIConstants{
  static AppBar appBar = AppBar(
    title: SvgPicture.asset(
      AssetsConstants.twitterLogo,
      color: Pallete.blueColor,
      height: 30,
    ),
  );
}
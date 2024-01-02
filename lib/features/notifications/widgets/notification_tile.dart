import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/models/model.dart' as model;
import 'package:twitter_clone/theme/pallete.dart';

class NotificationTile extends StatelessWidget {
  final model.Notification notification;

  const NotificationTile({
    super.key,
    required this.notification
    });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: 
      notification.notificationType == NotificationType.follow ? 
      const Icon(Icons.person, color:Pallete.blueColor,):
      notification.notificationType == NotificationType.like ?
      SvgPicture.asset(AssetsConstants.likeFilledIcon,
      // ignore: deprecated_member_use
      color: Pallete.redColor,height: 20,):
      notification.notificationType == NotificationType.retweet?
      SvgPicture.asset(AssetsConstants.retweetIcon,
      // ignore: deprecated_member_use
      color: Pallete.whiteColor,height: 20,):null,
      title: Text(notification.text),
    );
  }
}
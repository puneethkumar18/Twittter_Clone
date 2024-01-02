enum NotificationType{
  like('like'),
  reply('image'),
  follow('follow'),
  retweet('retweet');

  final String type;
  const NotificationType(this.type);

}

extension ConvertTweet on String{
  NotificationType toNotificationTypeEnum(){
    switch(this){
      case 'text' : return NotificationType.like;
      case 'image': return NotificationType.reply;
      case 'follow': return NotificationType.follow;
      case 'retweet': return NotificationType.retweet;
      default :return NotificationType.like;
    }
  }
}


import 'package:flutter/foundation.dart';

import 'package:twitter_clone/core/enums/tweet_type_enum.dart';

@immutable
class Tweet {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> commentIds;
  final List<String> likes;
  final String id;
  final String retweetedBy;
  final int reshareCount;
  final String repliedTo;
  const Tweet({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.tweetType,
    required this.tweetedAt,
    required this.commentIds,
    required this.likes,
    required this.id,
    required this.retweetedBy,
    required this.reshareCount,
    required this.repliedTo,
  });



  Tweet copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? commentIds,
    List<String>? likes,
    String? id,
    String? retweetedBy,
    int? reshareCount,
    String? repliedTo,
  }) {
    return Tweet(
      text:text ?? this.text,
      hashtags:hashtags ?? this.hashtags,
      link:link ?? this.link,
      imageLinks:imageLinks ?? this.imageLinks,
      uid:uid ?? this.uid,
      tweetType:tweetType ?? this.tweetType,
      tweetedAt:tweetedAt ?? this.tweetedAt,
      commentIds:commentIds ?? this.commentIds,
      likes:likes ?? this.likes,
      id:id ?? this.id,
      retweetedBy:retweetedBy ?? this.retweetedBy,
      reshareCount:reshareCount ?? this.reshareCount,
      repliedTo:repliedTo ?? this.repliedTo, 
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'text': text});
    result.addAll({'hashtags': hashtags});
    result.addAll({'link': link});
    result.addAll({'imageLinks': imageLinks});
    result.addAll({'uid': uid});
    result.addAll({'tweetType': tweetType.type});
    result.addAll({'tweetedAt': tweetedAt.millisecondsSinceEpoch});
    result.addAll({'commentIds': commentIds});
    result.addAll({'likes': likes});
    result.addAll({'retweetedBy': retweetedBy});
    result.addAll({'reshareCount': reshareCount});
    result.addAll({'repliedTo': repliedTo});
  
    return result;
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text:map['text'] ?? '',
      hashtags :List<String>.from(map['hashtags']),
      link:map['link'] ?? '',
      imageLinks:List<String>.from(map['imageLinks']),
      uid:map['uid'] ?? '',
      tweetType:(map['tweetType'] as String).toTweetTypeEnum(),
      tweetedAt:DateTime.fromMillisecondsSinceEpoch(map['tweetedAt']),
      commentIds:List<String>.from(map['commentIds']),
      likes:List<String>.from(map['likes']),
      id:map['\$id'] ?? '',
      retweetedBy:map['retweetedBy'] ?? '',
      reshareCount:map['reshareCount']?.toInt() ?? 0,
      repliedTo:map['repliedTo'] ?? '',
    );
  }



  @override
  String toString() {
    return 'Tweet(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, tweetedAt: $tweetedAt, commentIds: $commentIds, likes: $likes, id: $id, retweetedBy: $retweetedBy, reshareCount: $reshareCount, repliedTo: $repliedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Tweet &&
      other.text == text &&
      listEquals(other.hashtags, hashtags) &&
      other.link == link &&
      listEquals(other.imageLinks, imageLinks) &&
      other.uid == uid &&
      other.tweetType == tweetType &&
      other.tweetedAt == tweetedAt &&
      listEquals(other.commentIds, commentIds) &&
      listEquals(other.likes, likes) &&
      other.id == id &&
      other.retweetedBy == retweetedBy &&
      other.reshareCount == reshareCount &&
      other.repliedTo == repliedTo;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      hashtags.hashCode ^
      link.hashCode ^
      imageLinks.hashCode ^
      uid.hashCode ^
      tweetType.hashCode ^
      tweetedAt.hashCode ^
      commentIds.hashCode ^
      likes.hashCode ^
      id.hashCode ^
      retweetedBy.hashCode ^
      reshareCount.hashCode ^
      repliedTo.hashCode;
  }
}
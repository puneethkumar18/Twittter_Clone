
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/provider.dart';
import 'package:twitter_clone/models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweeAPI(
    db: ref.watch(appWriteDatabasesProvider),
    realtime: ref.watch(appWriteRealTimeProvider)
    );
});



abstract class ITweetAPI{
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
  Future<List<Document> > getRepliesToTweet(Tweet tweet);
  Future<Document> getTweetById(String id);
  Future<List<Document>> getUserTweets(String uid);
  Future<List<Document> > getTweetsByHashtag(String hashtag);
 
}

class TweeAPI implements ITweetAPI{
  final Databases _db;
  final Realtime _realtime;
  TweeAPI({
    required Databases db,
    required Realtime realtime}) : 
    _db = db, 
    _realtime = realtime;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(databaseId: AppwriteConstants.databaseId, 
      collectionId: AppwriteConstants.tweetCollection, 
      documentId: ID.unique(), 
      data: tweet.toMap()
      );
      return right(document);
    } on AppwriteException catch (e,st) {
      return left(
        Failure(
          e.message ?? "Some Unexpected Error Occured", 
          st
          ));
    } catch (e, st){
      return left(Failure(e.toString(),st));
    }
  }
  
  @override
  Future<List<Document> > getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId, 
    collectionId: AppwriteConstants.tweetCollection,
    queries: [
      Query.orderDesc('tweetedAt'),
    ]
    );
    return documents.documents;
  }
  
  @override
  Stream<RealtimeMessage> getLatestTweet()  {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetCollection}.documents'
    ]).stream;
  }
  
  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId, 
        collectionId: AppwriteConstants.tweetCollection, 
        documentId: tweet.id, 
        data: {
          'likes':tweet.likes
        },
        );
      return right(document);
    } on AppwriteException catch (e,st) {
      return left(Failure(
        e.message ?? "Some unexpected Error Occurred"
        , st)
        );

    } catch (e,stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
  
  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) async{
    try {
      final document = await _db.updateDocument(
      databaseId: AppwriteConstants.databaseId, 
      collectionId: AppwriteConstants.tweetCollection, 
      documentId: tweet.id,
      data: {
        'reshareCount': tweet.reshareCount,
      }
      );
      return right(document);
      
    } on AppwriteException catch (e,st) {
      return left(Failure(
        e.message ?? "Some Unexpected Error Occured", 
        st
      ));
    } catch(e,st){
      return left(Failure(
        e.toString(), 
        st)
        );
    }
  }
  
  @override
  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId, 
      collectionId: AppwriteConstants.tweetCollection,
      queries: [
        Query.equal('repliedTo', tweet.id),
      ]
      );
      return documents.documents;
  }
  
  @override
  Future<Document> getTweetById(String id)async {
    return  await _db.getDocument(
      databaseId: AppwriteConstants.databaseId, 
      collectionId: AppwriteConstants.tweetCollection, 
      documentId: id);
  }
  
  @override
  Future<List<Document>> getUserTweets(String uid)async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId, 
      collectionId: AppwriteConstants.tweetCollection,
      queries: [
        Query.equal('uid', uid)
      ]
      );
      return documents.documents;
  }
  
  @override
  Future<List<Document>> getTweetsByHashtag(String hashtag)async {
   final documents = await _db.listDocuments(
    databaseId: AppwriteConstants.databaseId, 
    collectionId: AppwriteConstants.tweetCollection,
    queries: [
      Query.search('hashtags', hashtag),
    ]
    );

    return documents.documents;
  }
  
 
}
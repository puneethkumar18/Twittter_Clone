import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart'as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/provider.dart';
import 'package:twitter_clone/models/user_model.dart';

final userAPIProvider = Provider ((ref) {
  final db = ref.watch(appWriteDatabasesProvider);
  return UserAPI(db: db);
});

abstract class IUserAPI{
  FutureEithervoid saveUserData(UserModel userModel);
  Future<models.Document> getUserData(String uid);
  Future<List<models.Document>> searchUserByName(String name);
  FutureEithervoid updateUserData(UserModel userModel);
}

class UserAPI extends IUserAPI{
  final Databases _db;
  UserAPI({required Databases db}):_db = db;


  @override
  Future<models.Document> getUserData(String uid) {
    final document =  _db.getDocument(databaseId: AppwriteConstants.databaseId, 
    collectionId: AppwriteConstants.usersCollection, 
    documentId: uid
    );
    return document;
  }
  
  @override
  FutureEithervoid saveUserData(UserModel userModel) async{
    try {
        await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
       data: userModel.toMap());
       return right(null);
    } on AppwriteException catch (e , stackTrace) {
      return left(
          Failure(e.toString(), stackTrace)
        );
    }catch(e,stackTrace){
      return left(Failure(e.toString(), stackTrace));
    }

}

  @override
  Future<List<models.Document>> searchUserByName(String name) async{
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId, 
      collectionId: AppwriteConstants.usersCollection,
      queries: [
        Query.search('name', name),
      ]
      );
      return documents.documents;
  }
  
  @override
  FutureEithervoid updateUserData(UserModel userModel) async {
   try {
     await _db.updateDocument(
      databaseId: AppwriteConstants.databaseId, 
      collectionId: AppwriteConstants.tweetCollection, 
      documentId: userModel.uid,
      data: userModel.toMap(),
      );
     return right(null);
   }on AppwriteException catch(e,stackTrace){
        return left(Failure(e.toString(), stackTrace));
   } catch (e,stackTrace) {
    return left(Failure(e.toString(), stackTrace));
   }
  }


}
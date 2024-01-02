class AppwriteConstants {
  static const String databaseId = '65752338dbd5203a00b2';
  static const String projectId = '65730afb47cb56e2701e';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String usersCollection = '6575236c3f0136930930';
  static const String tweetCollection = '';
  static const String notificationsCollection = '';

  static const String imagesBucket = '';
 

  static String imageUrl(String imageId) =>
  '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}

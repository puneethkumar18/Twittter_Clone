import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';

final appWriteClientProvider = Provider((ref) {
  return Client()
  .setEndpoint(AppwriteConstants.endPoint)
  .setProject(AppwriteConstants.projectId)
  .setSelfSigned(status: false);
});

final appWriteAccountProvider = Provider((ref) {
  return Account(ref.watch(appWriteClientProvider));
});
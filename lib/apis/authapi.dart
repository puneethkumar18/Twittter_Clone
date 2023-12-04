import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/provider.dart';


final authAPIProvider = Provider((ref) {
  return AuthAPI(account: ref.watch(appWriteAccountProvider));
});



abstract class IAuthAPI{
  FutureEither<models.User> signUp({
    required String email, 
    required String password});
    
}

class AuthAPI implements IAuthAPI{
  final Account _account;
  const AuthAPI({required Account account}) : _account = account;
  
  @override
  FutureEither<models.User> signUp({required String email, required String password}) async {
   try {
    final account = await _account.create(userId: ID.unique(), email: email, password: password);
   return right(account);
   } catch (e , stackTrace) {
     return left(Failure(e.toString(), stackTrace));
   }
  }

 
  }

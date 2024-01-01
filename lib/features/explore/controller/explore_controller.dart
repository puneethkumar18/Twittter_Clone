import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/models/user_model.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return ExploreController(userAPI: userAPI) ; 
});

final searchUserProvider = FutureProvider.family((ref,String name) async {
  final explorecontroller = ref.watch(exploreControllerProvider.notifier);
  return explorecontroller.searchUser(name);
});

class ExploreController extends StateNotifier {
  final UserAPI _userAPI;
  ExploreController({
    required UserAPI userAPI
  }):_userAPI=userAPI, super(false);


  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userAPI.searchUserByName(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }

}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/auth/controller/authapi_controller.dart';
import 'package:twitter_clone/features/user_profile/contoller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/views/user_profile_view.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;

    if(currentUser == null){
      return const Loader();
    }
    return SafeArea(
      child: Drawer(
        backgroundColor:Colors.black,
        child: Column(
          children: [
            const SizedBox(height:50 ,),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,),
              title: const Text(
                'My Profile',
              style: TextStyle(
                fontSize: 22
              ),
              ),
              onTap: (){
                Navigator.push(context, 
                UserProfileView.route(currentUser)
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.payment,
                size: 30,),
              title: const Text(
                'Twitter Blue',
              style: TextStyle(
                fontSize: 22
              ),
              ),
              onTap: (){
                ref.read(userProfileControllerProvider.notifier).
                updateUserProfile(
                  userModel: currentUser.copyWith(
                    isTwitterblue: true,
                  ), 
                  context: context, 
                  bannerFile: null, 
                  profileFile: null,
                  );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,),
              title: const Text(
                'Log Out',
              style: TextStyle(
                fontSize: 22
              ),
              ),
              onTap: (){
                ref.read(authControllerProvider.notifier).logout(context);
              },
            )
        ],
        ),
      ),
      );
  }
}
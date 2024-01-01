import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/auth/controller/authapi_controller.dart';
import 'package:twitter_clone/features/user_profile/contoller/user_profile_controller.dart';
import 'package:twitter_clone/theme/pallete.dart';

class EditProfieView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const EditProfieView());
  const EditProfieView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfieviewState();
}

class _EditProfieviewState extends ConsumerState<EditProfieView> {
  late TextEditingController nameController ;
  late TextEditingController bioController ;
  File? bannerFile;
  File? profileFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: ref.read(
        currentUserDetailProvider).
        value?.name?? ''
        );
      bioController = TextEditingController(
        text: ref.read(
        currentUserDetailProvider).
        value?.bio?? ''
        );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }
  void selectBannerImage()async{
    final banner = await pickImage();
    if(banner != null){
      bannerFile = banner;
    }
  }
  void selectProfileImage()async{
    final profile = await pickImage();
    if(profile != null){
      bannerFile = profile;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: (){
              ref.read(userProfileControllerProvider.notifier).
              updateUserProfile(
                userModel: user!.copyWith(
                  bio: bioController.text,
                  name: nameController.text,
                ), 
                context: context, 
                bannerFile: bannerFile, 
                profileFile: profileFile
                );
            }, 
            child: const Text('Save'),
            ),
        ],
      ),
      body: isLoading || user == null? const Loader(): Column(
        children: [
          GestureDetector(
            onTap: selectBannerImage,
            child: SizedBox(
              height: 200,
              child: Stack(
                  children:[
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: bannerFile != null ? 
                      Image.file(bannerFile!,
                      fit: BoxFit.fitWidth,
                      ):
                      user.bannerPic.isEmpty ? 
                    Container(
                    color: Pallete.blueColor,
                  ): Image.network(
                    user.bannerPic,
                    fit: BoxFit.fitWidth
                  ,)
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: GestureDetector(
                      onTap: selectProfileImage,
                      child: profileFile != null ? 
                      CircleAvatar(
                        backgroundImage:  FileImage(profileFile!),
                        radius: 40,
                      ):
                       CircleAvatar(
                        backgroundImage:  NetworkImage(
                          user.profilePic,
                        ),
                        radius: 40,
                      ),
                    ),
                  ),
                  
                      ],
                    ),
            ),
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Name',
              contentPadding:  EdgeInsets.all(18),
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            controller: bioController,
            decoration: const InputDecoration(
              hintText: 'Bio',
              contentPadding:  EdgeInsets.all(18),
            ),
            maxLines: 4,
          )
        ]
      )
    );
  }
}
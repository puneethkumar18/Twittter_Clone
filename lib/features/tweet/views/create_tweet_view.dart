
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../auth/controller/authapi_controller.dart';


class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const CreateTweetScreen());
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final tweetTextEditingController = TextEditingController();
  List<File> images = [];
  @override
  void dispose() {
    super.dispose();
    tweetTextEditingController.dispose();
  }

  void shareTweet(){
    ref.read(tweetControllerProvider.notifier).shareTweet(
      images: images, 
      text: tweetTextEditingController.text, 
      context: context,
      repliedTo: '',
      repliedToUserId: ''
      );
      Navigator.pop(context);
  }
  void onPickImages()async{
    images =  await pickImages();
    setState(() {
      
    });
  }
 
  @override
  Widget build(BuildContext context) {
   final currentUser = ref.watch(currentUserDetailProvider).value;
   final isLoading = ref.watch(tweetControllerProvider);
   
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close,size: 30,),
          onPressed: (){
            Navigator.pop(context);
          },
      ),
      actions: [
        RoundedButton(label: 'Tweet', 
        color: Colors.white, 
        backgroundcolor: Pallete.blueColor, 
        ontap: shareTweet)
        ],
      ),
      body: isLoading || currentUser == null ? const Loader(): SafeArea(
        child: SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              Row(
                children: [
                   const CircleAvatar(
                    //backgroundImage: NetworkImage(currentUser!.profilePic),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: 
                    TextFormField(
                      controller: tweetTextEditingController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "What's happing ? ",
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ],
              ),
              if(images.isNotEmpty)
              CarouselSlider(items: images
              .map(
                (file) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child:Image.file(file)
                    );
                  }
                ).toList(),
                 options: CarouselOptions(
                  height: 400,
                  enableInfiniteScroll: false,
                 ),
                 ),
            ],
          ),
          )
        ),
        ),
        bottomNavigationBar: Container(
          padding:const  EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Pallete.greyColor,
                width:0.3 ,
                ),
                ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(
                  left: 15,
                  right: 15,
                ),
                child: GestureDetector(
                  onTap: onPickImages,
                  child: SvgPicture.asset(AssetsConstants.galleryIcon)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(
                  left: 15,
                  right: 15,
                ),
                child: GestureDetector(
                  child: SvgPicture.asset(AssetsConstants.gifIcon)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(
                  left: 15,
                  right: 15,
                ),
                child: GestureDetector(
                  child: SvgPicture.asset(AssetsConstants.emojiIcon)),
                ),
            ],
          ),
        ),
    );
  }
}
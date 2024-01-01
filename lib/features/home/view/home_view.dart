import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/views/create_tweet_view.dart';
import 'package:twitter_clone/theme/pallete.dart';


class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context)=>const HomeView());  
  @override
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViWState();
}

class _HomeViWState extends State<HomeView> {
  int _page = 0;
  final appBar = UIConstants.appBar;

  void onPageChange(int index){
      setState(() {
        _page = index;
      });
  }

   onCreateTweet(){
    Navigator.push(context, CreateTweetScreen.route());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appBar : null,
      body: IndexedStack(
          index: _page,
          children: UIConstants.bottomTapBarPages,
      ),
      floatingActionButton: FloatingActionButton(onPressed: onCreateTweet,
      backgroundColor: Pallete.blueColor,
      child:   const Icon(Icons.add,
      color: Pallete.whiteColor,
      size: 28,
      ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0 ?
              AssetsConstants.homeFilledIcon:AssetsConstants.homeOutlinedIcon,
            // ignore: deprecated_member_use
            color: Pallete.whiteColor,)
            ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 1 ?
              AssetsConstants.searchIcon:
              AssetsConstants.searchIcon,
            // ignore: deprecated_member_use
            color: Pallete.whiteColor,
            )
            ),
            BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2 ?
              AssetsConstants.notifFilledIcon:
              AssetsConstants.notifOutlinedIcon,
              // ignore: deprecated_member_use
              color: Pallete.whiteColor,
            )
            ),
          ]),
    );
  }
}
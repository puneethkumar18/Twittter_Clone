import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/erorr_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/auth/controller/authapi_controller.dart';
import 'package:twitter_clone/features/auth/view/signup_page.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/theme/app_theme.dart';


void main() {
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Twitter Clone",
      theme: AppTheme.theme,
       home: ref.watch(currentUserAccountProvider).when
       (data: (user){
       if(user != null){
         return const HomeView();
       }
       return const SignUpPage();
     }, error: (erorr,st){
       return ErorrPage(erorrtext: erorr.toString());
     }, loading: ()=> const LoadingPage(),
     )
    );

  

  }
}
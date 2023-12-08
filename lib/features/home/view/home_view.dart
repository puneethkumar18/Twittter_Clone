import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/authapi_controller.dart';
import 'package:twitter_clone/features/auth/view/signup_page.dart';

class HomeView extends ConsumerWidget {
  static route() => MaterialPageRoute(builder: (context)=>const HomeView());
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserProvider).when
    (data: (user){
      if(user != null){
        return const HomeView();
      }
      return const SignUpPage();
    }, error: (erorr,st){
      return ErorrPage(erorrtext: erorr.toString());
    }, loading: ()=> const LoadingPage());
  }
  }

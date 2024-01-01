
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/common/rounded_button.dart';
import 'package:twitter_clone/constants/ui_constants.dart';
import 'package:twitter_clone/features/auth/controller/authapi_controller.dart';
import 'package:twitter_clone/features/auth/view/login_page.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';

class SignUpPage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());
  const SignUpPage({super.key});
  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }
  
 void onSignUp(){
  ref.read(authControllerProvider.notifier).
  signUp(email: emailcontroller.text, password: passwordcontroller.text, context: context);
 }
  @override
  Widget build(BuildContext context) {
    final isloading = ref.watch(authControllerProvider);
    return  Scaffold(
      appBar: AppBar(
        title: UIConstants.appBar,
      ),
      body: isloading ? const Loader() : Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 240,),
              AuthField(controller: emailcontroller,hinttext: 'Email',),
              const SizedBox(height: 20,),
              AuthField(controller: passwordcontroller,hinttext: "Password",),
              const SizedBox(height: 20,),
              Align(
                alignment: Alignment.topRight,
                child:  RoundedButton(
                  ontap: onSignUp,
                  label: 'Done',
                  color: Colors.black,
                  backgroundcolor: Colors.white70,),
                  ),
              const SizedBox(height: 30,),
              RichText(text:  TextSpan(text: 
              'Already have an account?',
              style: const TextStyle(
                fontSize: 16),
                children: [
                  TextSpan(
                    text: ' Login',
                    style: const TextStyle(fontSize: 16,
                    color: Colors.blue),
                    recognizer: TapGestureRecognizer()..onTap = (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    ),
                ]
                ),
                ),
            ]
            ),
        ),
      ),
    );
  }
}
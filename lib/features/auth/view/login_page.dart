import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/rounded_button.dart';
import 'package:twitter_clone/constants/ui_constants.dart';
import 'package:twitter_clone/features/auth/controller/authapi_controller.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context)=>const LoginPage());
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  void onLogIn(){
    ref.read(authControllerProvider.notifier).
    logIn(email: emailcontroller.text, 
    password: passwordcontroller.text, 
    context: context
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstants.appBar,
      body:  Padding(
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
                  ontap: onLogIn,
                  label: 'Done',
                  color: Colors.black,
                  backgroundcolor: Colors.white70,),
                  ),
              const SizedBox(height: 30,),
              RichText(text:  TextSpan(text: 
              "Don't have an Account?",
              style: const TextStyle(
                fontSize: 16),
                children: [
                  TextSpan(
                    text: ' Sign Up',
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
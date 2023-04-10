import 'package:clonetwit/common/rounded_small_button.dart';
import 'package:clonetwit/constants/constants.dart';
import 'package:clonetwit/features/auth/view/signup_view.dart';
import 'package:clonetwit/features/auth/widgets/auth_field.dart';
import 'package:clonetwit/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginView());
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final appbar = UIConstants.appBar();
  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              AuthField(
                hintText: 'Email',
                controller: emailcontroller,
              ),
              const SizedBox(
                height: 25,
              ),
              AuthField(
                hintText: 'Password',
                controller: passwordcontroller,
              ),
              Align(
                alignment: Alignment.topRight,
                child: RoundedSmallButton(
                  label: 'Done',
                  onTap: () {},
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              RichText(
                text: TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                          text: " Sign up",
                          style: const TextStyle(
                              color: Pallete.blueColor, fontSize: 16),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(context, SignUpView.route());
                            })
                    ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}

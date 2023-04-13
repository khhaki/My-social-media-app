import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/constants/ui_constants.dart';
import 'package:clonetwit/features/auth/controller/auth_controller.dart';
import 'package:clonetwit/features/auth/view/login_view.dart';
import 'package:clonetwit/features/auth/widgets/auth_field.dart';
import 'package:clonetwit/theme/pallete.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpView());

  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();

  final appbar = UIConstants.appBar();
  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
        email: emailcontroller.text,
        password: passwordcontroller.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading
          ? const Loader()
          : Center(
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
                        onTap: onSignUp,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Already have an account?",
                          style: const TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                                text: " Login",
                                style:
                                    // ignore: prefer_const_constructors
                                    TextStyle(
                                        color: Pallete.blueColor, fontSize: 16),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, LoginView.route());
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

import 'package:clonetwit/common/error_page.dart';
import 'package:clonetwit/common/loading_page.dart';
import 'package:clonetwit/features/auth/controller/auth_controller.dart';
import 'package:clonetwit/features/auth/view/signup_view.dart';
import 'package:clonetwit/features/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
          data: (user) {
            if (user != null) {
              return const HomeView();
            }
            return const SignUpView();
          },
          error: (error, st) {
            return ErrorPage(error: error.toString());
          },
          loading: () => const LoadingPage()),
    );
  }
}

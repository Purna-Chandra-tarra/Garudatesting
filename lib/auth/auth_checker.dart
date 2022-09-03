import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/pages/error_page.dart';
import 'package:garudaexams_dashboard/presentation/pages/home_page.dart';
import 'package:garudaexams_dashboard/presentation/pages/loading_page.dart';
import 'package:garudaexams_dashboard/presentation/pages/sign_in_page.dart';

import '../../providers/providers.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (data) {
        if (data != null) return const HomePage();
        return SignInPage();
      },
      loading: () => const LoadingPage(),
      error: (e, trace) => ErrorPage(e, trace),
    );
  }
}

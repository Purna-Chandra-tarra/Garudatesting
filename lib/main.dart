import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/pages/error_page.dart';
import 'package:garudaexams_dashboard/presentation/pages/loading_page.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

import 'auth/auth_checker.dart';
import 'presentation/destinations/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialize = ref.watch(firebaseinitializerProvider);
    return MaterialApp(
      title: 'Garuda Exams Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff7c79fc),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff7c79fc),
          brightness: Brightness.dark,
        ),
      ),
      home: initialize.when(
        data: (app) => const AuthChecker(),
        loading: () => const LoadingPage(),
        error: (e, stackTrace) {
          ErrorPage(e, stackTrace);
          return null;
        },
      ),
    );
  }
}

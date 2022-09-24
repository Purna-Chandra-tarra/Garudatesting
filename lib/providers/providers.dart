import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/auth/auth_service.dart';
import 'package:garudaexams_dashboard/domain/databases/exam_database.dart';
import 'package:garudaexams_dashboard/domain/databases/query_database.dart';
import 'package:garudaexams_dashboard/domain/databases/user_database.dart';
import 'package:garudaexams_dashboard/firebase_options.dart';

final destinationProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});
final destinationExamProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});
final firebaseinitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey:
        '6LfCxiUiAAAAACzcdmzCqTkFJrPhKH52nLl6Ui-f', // If you're building a web app.
  );
  return app;
});
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChange;
});

final authServiceProvider = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService();
});

final examDatabaseProvider = Provider<ExamDatabase>((ref) {
  return ExamDatabase();
});
final userDatabaseProvider = Provider<UserDatabase>((ref) {
  return UserDatabase();
});
final queryDatabaseProvider = Provider<QueryDatabase>((ref) {
  return QueryDatabase();
});

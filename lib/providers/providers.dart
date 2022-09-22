import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/auth/auth_service.dart';
import 'package:garudaexams_dashboard/domain/databases/exam_database.dart';
import 'package:garudaexams_dashboard/domain/databases/user_database.dart';
import 'package:garudaexams_dashboard/firebase_options.dart';

final destinationProvider = StateProvider<int>((ref) {
  return 0;
});

final firebaseinitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

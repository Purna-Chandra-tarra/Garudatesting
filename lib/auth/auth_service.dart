// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _user;
  late User? _user;
  Stream<User?> get authStateChange => _auth.authStateChanges();

  AuthService() {
    _auth.authStateChanges().listen((user) {
      _user = user;

      notifyListeners();
    });
    _auth.setSettings(appVerificationDisabledForTesting: true);
  }

  Future<void> changeAccountPassword(String newPassword) async {
    await _user!.updatePassword(newPassword);
  }

  Future<String> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Signed In";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

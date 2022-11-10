import 'package:cloud_firestore/cloud_firestore.dart';

class MasterPasswordDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _passwordCollection;
  Future updatePassword({
    required String password,
  }) async {
    _passwordCollection = _firestore.collection('password');
    try {
      await _passwordCollection.doc("password").update(
        {
          "password": password,
        },
      );
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getPassword() async {
    _passwordCollection = _firestore.collection('password');
    String password = await _passwordCollection
        .doc("password")
        .get()
        .then((value) => value['password']);

    return password;
  }
}

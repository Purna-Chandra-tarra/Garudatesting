import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _examCollection;

  Stream getUserList() {
    _examCollection = _firestore.collection('users');
    Stream stream = _examCollection.snapshots();
    return stream;
  }

  //is super user
  Future<bool> isSuperUser(String email) async {
    return await _firestore
        .collection('admins')
        .doc(email)
        .get()
        .then((value) => value['super_user']);
  }
}

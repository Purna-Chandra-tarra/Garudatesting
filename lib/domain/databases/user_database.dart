import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _examCollection;

  Stream getUserList() {
    _examCollection = _firestore.collection('users');
    Stream stream = _examCollection.snapshots();
    return stream;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _examCollection;

  Stream<QuerySnapshot> getUserList() {
    _examCollection = _firestore.collection('users');
    Stream<QuerySnapshot> stream = _examCollection.snapshots();
    return stream;
  }

  Future changeStudentStatus(String phoneNo) async {
    await _firestore.collection('users').doc(phoneNo).update(
      {'device_id': 'error'},
    );
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

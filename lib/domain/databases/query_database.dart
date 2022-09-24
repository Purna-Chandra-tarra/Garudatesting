import 'package:cloud_firestore/cloud_firestore.dart';

class QueryDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _examCollection;

  Stream getQueryList() {
    _examCollection = _firestore.collection('query');
    Stream stream = _examCollection.snapshots();
    return stream;
  }

  Future deleteQuery(String id) async {
    await _examCollection.doc(id).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garudaexams_dashboard/data/models/exam_model.dart';

class ExamDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _examCollection;

  Stream getExamList() {
    _examCollection = _firestore.collection('exam');
    Stream stream =
        _examCollection.orderBy("exam_id", descending: false).snapshots();
    return stream;
  }

  Stream getSubscription(String examId) {
    _examCollection = _firestore.collection('exam');
    Stream stream =
        _examCollection.doc(examId).collection('subscriptions').snapshots();
    return stream;
  }

  Future<int> getExamLength(String examId) async {
    _examCollection = _firestore.collection('exam');
    QuerySnapshot snapshot =
        await _examCollection.doc(examId).collection('questions').get();
    return snapshot.docs.length;
  }

  Stream getExam(String examId) {
    _examCollection = _firestore.collection('exam');
    Stream exam = _examCollection.doc(examId).snapshots();
    return exam;
  }

  Future updateExamStatus(bool status, String examId) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection.doc(examId).update({
        "active": status,
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateExamType(String type, String examId) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection.doc(examId).update({
        "type": type,
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateDifficultyType(String diff, String examId) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection.doc(examId).update({
        "difficulty_level": diff,
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteExam(String examId) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection.doc(examId).delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future addExam(Exam exam) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection.doc(exam.examId.toString()).set({
        "exam_id": exam.examId,
        "exam_name": exam.examName,
        "type": exam.examType,
        "difficulty_level": exam.difficulty,
        "active": exam.active,
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Stream getSubject(String examId) {
    _examCollection = _firestore.collection('exam');
    Stream subject =
        _examCollection.doc(examId).collection('subjects').snapshots();
    return subject;
  }

  Stream getSection(String examId) {
    _examCollection = _firestore.collection('exam');
    Stream subject =
        _examCollection.doc(examId).collection('sections').snapshots();
    return subject;
  }

  Future deleteExamSubject(String examId, String subjectId) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection
          .doc(examId)
          .collection('subjects')
          .doc(subjectId)
          .delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future addExamSubject(
      String examId, String subjectName, String subjectId) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection
          .doc(examId)
          .collection('subjects')
          .doc(subjectId)
          .set({
        "name": subjectName,
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteExamSection(String examId, String sectionId) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection
          .doc(examId)
          .collection('sections')
          .doc(sectionId)
          .delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future addExamSection(
      String examId, String sectionName, String sectionId) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection
          .doc(examId)
          .collection('sections')
          .doc(sectionId)
          .set({
        "section": sectionName,
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future addSubscription(
      {required String examId,
      required int amount,
      required String features,
      required String id,
      required int period}) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection.doc(examId).collection('subscriptions').doc().set({
        "amount": amount,
        "features": features,
        "id": id,
        "period": period,
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteSubscription(String examId, String subscriptionId) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection
          .doc(examId)
          .collection('subscriptions')
          .doc(subscriptionId)
          .delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

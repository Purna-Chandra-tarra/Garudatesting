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
}

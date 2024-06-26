import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/data/models/exam_model.dart';

class ExamDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _examCollection;
  int pageSize = 10;

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

  Stream<DocumentSnapshot> getExam(String examId) {
    _examCollection = _firestore.collection('exam');
    return _examCollection.doc(examId).snapshots();
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

  Future updateYoutube(bool value, String examId) async {
    _examCollection = _firestore.collection('exam');
    try {
      await _examCollection.doc(examId).update({
        "youtube": value,
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
        "youtube": exam.youtube,
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

  Future<int> getSubjectLength(String examId, String subject) async {
    _examCollection = _firestore.collection('exam');
    QuerySnapshot snapshot = await _examCollection
        .doc(examId)
        .collection('questions')
        .where("subject", isEqualTo: subject)
        .get();
    return snapshot.docs.length;
  }

  Future<int> getSectionLength(String examId, String section) async {
    _examCollection = _firestore.collection('exam');
    QuerySnapshot snapshot = await _examCollection
        .doc(examId)
        .collection('questions')
        .where("section", isEqualTo: section)
        .get();
    return snapshot.docs.length;
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

  Future<List<String>> getSubjectList(String examId) async {
    _examCollection = _firestore.collection('exam');
    List<String> subjectList = [];
    QuerySnapshot snapshot =
        await _examCollection.doc(examId).collection('subjects').get();
    for (var element in snapshot.docs) {
      subjectList.add(element['name']);
    }
    return subjectList;
  }

  Future<List<String>> getSectionList(String examId) async {
    _examCollection = _firestore.collection('exam');
    List<String> sectionList = [];
    QuerySnapshot snapshot =
        await _examCollection.doc(examId).collection('sections').get();
    for (var element in snapshot.docs) {
      sectionList.add(element['section']);
    }
    return sectionList;
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

  Query<Map<String, dynamic>> getQuestions(String examId, WidgetRef ref) {
    _examCollection = _firestore.collection('exam');
    return _examCollection.doc(examId).collection('questions');
  }

  Future updateQuestion(
      String examId, String questionId, Map<String, Object> map) async {
    CollectionReference questionCollection =
        _firestore.collection('exam').doc(examId).collection('questions');
    try {
      await questionCollection.doc(questionId).update(map);
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future addQuestion(
      String examId, String questionId, Map<String, Object> map) async {
    CollectionReference questionCollection =
        _firestore.collection('exam').doc(examId).collection('questions');
    try {
      await questionCollection.doc(questionId).set(map);
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteQuestion(String examId, String questionId) async {
    CollectionReference questionCollection =
        _firestore.collection('exam').doc(examId).collection('questions');
    try {
      await questionCollection.doc(questionId).delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

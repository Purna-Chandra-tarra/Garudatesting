// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/domain/databases/exam_database.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';

import '../../providers/providers.dart';

class Question extends ConsumerStatefulWidget {
  const Question({
    Key? key,
    required this.examId,
  }) : super(key: key);

  final String examId;

  @override
  ConsumerState<Question> createState() => _QuestionState();
}

class _QuestionState extends ConsumerState<Question> {
  final TextEditingController questionController = TextEditingController();

  final TextEditingController questionEquationController =
      TextEditingController();

  final TextEditingController optionController = TextEditingController();

  final TextEditingController explanationMatterController =
      TextEditingController();

  final TextEditingController explanationHeadingController =
      TextEditingController();

  final TextEditingController searchController = TextEditingController();

  bool searchType = false;

  @override
  void dispose() {
    super.dispose();

    questionController.dispose();
    questionEquationController.dispose();
    optionController.dispose();
    explanationMatterController.dispose();
    searchController.dispose();
  }

  // whether we are showing search or not
  bool showingSearch = false;

  @override
  Widget build(BuildContext context) {
    ExamDatabase examDatabase = ref.watch(examDatabaseProvider);

    return Padding(
      padding: EdgeInsets.all(!Platform.isAndroid ? 0 : 20),
      child: Column(
        children: [
          _buildPlatformDependentHeader(context),
          if (!Platform.isAndroid) const SizedBox(height: 20),
          if (Platform.isAndroid && !showingSearch)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    showingSearch = !showingSearch;
                  });
                },
              ),
            ),
          if (Platform.isAndroid && showingSearch)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("ID Search"),
                    Transform.scale(
                      scale: .7,
                      child: Switch(
                        value: searchType,
                        onChanged: (value) => setState(
                          () {
                            searchType = value;
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.search_off),
                      onPressed: () {
                        setState(() {
                          showingSearch = !showingSearch;
                        });
                      },
                    ),
                  ],
                ),
                const Text("Question Search"),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: searchController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Question',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          Expanded(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: searchType
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: _buildFirstChild(context, examDatabase),
              secondChild: _buildSecondChild(context, examDatabase),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlatformDependentHeader(BuildContext context) {
    return !Platform.isAndroid
        ? Row(
            children: [
              Text(
                'Question',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              const Text("ID Search"),
              Switch(
                value: searchType,
                onChanged: (value) => setState(
                  () {
                    searchType = value;
                  },
                ),
              ),
              const Text("Question Search"),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: searchController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Question',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _buildFirstChild(BuildContext context, ExamDatabase examDatabase) {
    return FirestoreListView<Map<String, dynamic>>(
      query: searchController.text.isEmpty
          ? examDatabase.getQuestions(widget.examId, ref)
          : examDatabase.getQuestions(widget.examId, ref).where(
                FieldPath.documentId,
                isEqualTo: searchController.text,
              ),
      itemBuilder: (context, documentSnapshots) {
        Map<String, dynamic> docs = documentSnapshots.data();

        return !Platform.isAndroid
            ? _buildQuestionCard(documentSnapshots, context, examDatabase, docs)
            : Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                            '(${documentSnapshots.id}) ${docs['question']}'),
                      ),
                    ],
                  ),
                  children: [
                    _buildQuestionCard(
                        documentSnapshots, context, examDatabase, docs),
                  ],
                ),
              );
      },
    );
  }

  Card _buildQuestionCard(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshots,
      BuildContext context,
      ExamDatabase examDatabase,
      Map<String, dynamic> docs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Id: ${documentSnapshots.id}"),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    showLoaderDialog(context);
                    await examDatabase.deleteQuestion(
                      widget.examId,
                      documentSnapshots.id,
                    );
                    await ref.watch(storageProvider).deleteImage(
                          documentSnapshots.id,
                        );
                    await ref.watch(storageProvider).deleteQuestionImage(
                          documentSnapshots.id,
                        );
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    docs['question'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      questionController.text = docs['question'];
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Question",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: questionController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {"question": questionController.text},
                                  );
                                  questionController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: _getEquationComponentsWidgets(
                        docs['question_equation'] ?? "No Equation"),
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      questionEquationController.text =
                          docs['question_equation'] ?? '';
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Question Equation",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: questionEquationController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {
                                      "question_equation":
                                          questionEquationController.text
                                    },
                                  );
                                  questionEquationController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Option 1. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${docs['option_one']}",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      optionController.text = docs['option_one'];
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Option 1",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: optionController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {"option_one": optionController.text},
                                  );
                                  optionController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                      children: _getEquationComponentsWidgets(
                    docs['option_one_equation'] ?? "No Option 1 Equation",
                  )),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      questionEquationController.text =
                          docs['option_one_equation'] ?? '';
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Option 1 Equation",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: questionEquationController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {
                                      "option_one_equation":
                                          questionEquationController.text
                                    },
                                  );
                                  questionEquationController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Option 2. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${docs['option_two']}",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      optionController.text = docs['option_two'];
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Option 2",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: optionController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {"option_two": optionController.text},
                                  );
                                  optionController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                      children: _getEquationComponentsWidgets(
                    docs['option_two_equation'] ?? "No Option 2 Equation",
                  )),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      questionEquationController.text =
                          docs['option_two_equation'] ?? '';
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Option 2 Equation",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: questionEquationController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {
                                      "option_two_equation":
                                          questionEquationController.text
                                    },
                                  );
                                  questionEquationController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Option 3. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${docs['option_three']}",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      optionController.text = docs['option_three'];
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Option 3",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: optionController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {"option_three": optionController.text},
                                  );
                                  optionController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: _getEquationComponentsWidgets(
                        docs['option_three_equation'] ??
                            "No Option 3 Equation"),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      questionEquationController.text =
                          docs['option_three_equation'] ?? '';
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Option 3 Equation",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: questionEquationController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {
                                      "option_three_equation":
                                          questionEquationController.text
                                    },
                                  );
                                  questionEquationController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Option 4. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${docs['option_four']}",
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      optionController.text = docs['option_four'];
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Option 4",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: optionController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {"option_four": optionController.text},
                                  );
                                  optionController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: _getEquationComponentsWidgets(
                        docs['option_four_equation'] ?? "No Option 4 Equation"),
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      questionEquationController.text =
                          docs['option_four_equation'] ?? '';
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Option 4 Equation",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: questionEquationController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {
                                      "option_four_equation":
                                          questionEquationController.text
                                    },
                                  );
                                  questionEquationController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Youtube Link: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SelectableText(
                        "${docs['youtube_link']}",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      optionController.text = docs['youtube_link'];
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Youtube Link",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: optionController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {"youtube_link": optionController.text},
                                  );
                                  optionController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explanation Heading: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SelectableText(
                        "${docs['explanation_heading'] ?? ''}",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      explanationHeadingController.text =
                          docs['explanation_heading'] ?? '';
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Explanation Heading",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: explanationHeadingController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {
                                      "explanation_heading":
                                          explanationHeadingController.text
                                    },
                                  );
                                  explanationHeadingController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explanation Matter: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        children: _getEquationComponentsWidgets(
                            docs['explanation_matter'] ?? ''),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      explanationMatterController.text =
                          docs['explanation_matter'] ?? '';
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Explanation Matter",
                            ),
                            content: TextField(
                              controller: explanationMatterController,
                              minLines: 5,
                              maxLines: 10,
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {
                                      "explanation_matter":
                                          explanationMatterController.text,
                                    },
                                  );
                                  explanationMatterController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Answer: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Option ${docs['answer']}",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      optionController.text = docs['answer'].toString();
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Update Answer(1,2,3,4)",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: optionController,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text(
                                  "Cancel",
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text(
                                  "Update",
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {
                                      "answer":
                                          int.parse(optionController.text),
                                    },
                                  );
                                  optionController.clear();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Section: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${docs['section']}",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    showLoaderDialog(context);
                    List<String> sections =
                        await examDatabase.getSectionList(widget.examId);
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Select Sections"),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 500,
                                    width: 500,
                                    child: ListView.builder(
                                        itemCount: sections.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              child: Text(
                                                sections[index1],
                                              ),
                                              onPressed: () async {
                                                showLoaderDialog(context);
                                                await examDatabase
                                                    .updateQuestion(
                                                  widget.examId,
                                                  documentSnapshots.id,
                                                  {
                                                    "section": sections[index1],
                                                  },
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Subject: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${docs['subject']}",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    showLoaderDialog(context);
                    List<String> subjects =
                        await examDatabase.getSubjectList(widget.examId);
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Select Subject"),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 500,
                                    width: 500,
                                    child: ListView.builder(
                                        itemCount: subjects.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index1) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              child: Text(
                                                subjects[index1],
                                              ),
                                              onPressed: () async {
                                                showLoaderDialog(context);
                                                await examDatabase
                                                    .updateQuestion(
                                                  widget.examId,
                                                  documentSnapshots.id,
                                                  {
                                                    "subject": subjects[index1],
                                                  },
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? image =
                          await FilePicker.platform.pickFiles();

                      if (image != null) {
                        showLoaderDialog(context);
                        final imageUrl =
                            await ref.watch(storageProvider).uploadImages(
                                  documentSnapshots.id,
                                  image,
                                  ref,
                                );
                        await examDatabase.updateQuestion(
                          widget.examId,
                          documentSnapshots.id,
                          {
                            "image_url": imageUrl,
                          },
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Change Explanation Image"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: docs['image_url'] == null || docs['image_url'] == ""
                      ? const Icon(
                          Icons.image_not_supported,
                        )
                      : const Icon(Icons.image),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? image =
                          await FilePicker.platform.pickFiles();

                      // if image is not empty, we uplod it
                      if (image != null) {
                        showLoaderDialog(context);
                        final imageUrl = await ref
                            .watch(storageProvider)
                            .uploadQuestionImages(
                              documentSnapshots.id,
                              image,
                              ref,
                            );
                        await examDatabase.updateQuestion(
                          widget.examId,
                          documentSnapshots.id,
                          {
                            "question_image_url": imageUrl,
                          },
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Change Question Image"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: docs['question_image_url'] == null ||
                          docs['question_image_url'] == ""
                      ? const Icon(
                          Icons.image_not_supported,
                        )
                      : const Icon(Icons.image),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildSecondChild(BuildContext context, ExamDatabase examDatabase) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 164,
      width: MediaQuery.of(context).size.width,
      child: FirestoreListView<Map<String, dynamic>>(
        query: examDatabase
            .getQuestions(widget.examId, ref)
            .where(
              'question',
              isGreaterThanOrEqualTo: searchController.text,
            )
            .where(
              'question',
              isLessThan: '${searchController.text}z',
            ),
        itemBuilder: (context, documentSnapshots) {
          Map<String, dynamic> docs = documentSnapshots.data();

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Id: ${documentSnapshots.id}"),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                docs['question'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  questionController.text = docs['question'];
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Question",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: questionController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "question":
                                                      questionController.text
                                                },
                                              );
                                              questionController.clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                children: _getEquationComponentsWidgets(
                                  docs['question_equation'] ?? "No Equation",
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  questionEquationController.text =
                                      docs['question_equation'] ?? '';
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Question Equation",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  questionEquationController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "question_equation":
                                                      questionEquationController
                                                          .text
                                                },
                                              );
                                              questionEquationController
                                                  .clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Option 1. ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${docs['option_one']}",
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  optionController.text = docs['option_one'];
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Option 1",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: optionController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "option_one":
                                                      optionController.text
                                                },
                                              );
                                              optionController.clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                  children: _getEquationComponentsWidgets(
                                docs['option_one_equation'] ??
                                    "No Option 1 Equation",
                              )),
                            ),
                            IconButton(
                                onPressed: () {
                                  questionEquationController.text =
                                      docs['option_one_equation'] ?? '';
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Option 1 Equation",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  questionEquationController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "option_one_equation":
                                                      questionEquationController
                                                          .text
                                                },
                                              );
                                              questionEquationController
                                                  .clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Option 2. ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${docs['option_two']}",
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  optionController.text = docs['option_two'];
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Option 2",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: optionController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "option_two":
                                                      optionController.text
                                                },
                                              );
                                              optionController.clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                children: _getEquationComponentsWidgets(
                                  docs['option_two_equation'] ??
                                      "No Option 2 Equation",
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  questionEquationController.text =
                                      docs['option_two_equation'] ?? '';
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Option 2 Equation",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  questionEquationController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "option_two_equation":
                                                      questionEquationController
                                                          .text
                                                },
                                              );
                                              questionEquationController
                                                  .clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Option 3. ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${docs['option_three']}",
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  optionController.text = docs['option_three'];
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Option 3",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: optionController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "option_three":
                                                      optionController.text
                                                },
                                              );
                                              optionController.clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                  children: _getEquationComponentsWidgets(
                                docs['option_three_equation'] ??
                                    "No Option 3 Equation",
                              )),
                            ),
                            IconButton(
                                onPressed: () {
                                  questionEquationController.text =
                                      docs['option_three_equation'] ?? '';
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Option 3 Equation",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  questionEquationController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "option_three_equation":
                                                      questionEquationController
                                                          .text
                                                },
                                              );
                                              questionEquationController
                                                  .clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Option 4. ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${docs['option_four']}",
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  optionController.text = docs['option_four'];
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Option 4",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: optionController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "option_four":
                                                      optionController.text
                                                },
                                              );
                                              optionController.clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                  children: _getEquationComponentsWidgets(
                                docs['option_four_equation'] ??
                                    "No Option 4 Equation",
                              )),
                            ),
                            IconButton(
                                onPressed: () {
                                  questionEquationController.text =
                                      docs['option_four_equation'] ?? '';
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Option 4 Equation",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  questionEquationController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "option_four_equation":
                                                      questionEquationController
                                                          .text
                                                },
                                              );
                                              questionEquationController
                                                  .clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Youtube Link: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SelectableText(
                                    "${docs['youtube_link']}",
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  optionController.text = docs['youtube_link'];
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Youtube Link",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: optionController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "youtube_link":
                                                      optionController.text
                                                },
                                              );
                                              optionController.clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Explanation Heading: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SelectableText(
                                    "${docs['explanation_heading'] ?? ''}",
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  explanationHeadingController.text =
                                      docs['explanation_heading'] ?? '';
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Explanation Heading",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  explanationHeadingController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "explanation_heading":
                                                      explanationHeadingController
                                                          .text
                                                },
                                              );
                                              explanationHeadingController
                                                  .clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Explanation Matter: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                children: _getEquationComponentsWidgets(
                                    docs['explanation_matter'] ?? ''),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  explanationMatterController.text =
                                      docs['explanation_matter'] ?? '';
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Explanation Matter",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  explanationMatterController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "explanation_matter":
                                                      explanationMatterController
                                                          .text,
                                                },
                                              );
                                              explanationMatterController
                                                  .clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Answer: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Option ${docs['answer']}",
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  optionController.text =
                                      docs['answer'].toString();
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Update Answer(1,2,3,4)",
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: optionController,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              "Cancel",
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              "Update",
                                            ),
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              await examDatabase.updateQuestion(
                                                widget.examId,
                                                documentSnapshots.id,
                                                {
                                                  "answer": int.parse(
                                                      optionController.text),
                                                },
                                              );
                                              optionController.clear();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Section: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${docs['section']}",
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                showLoaderDialog(context);
                                List<String> sections = await examDatabase
                                    .getSectionList(widget.examId);
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Select Sections"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 500,
                                                width: 500,
                                                child: ListView.builder(
                                                    itemCount: sections.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index1) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ElevatedButton(
                                                          child: Text(
                                                            sections[index1],
                                                          ),
                                                          onPressed: () async {
                                                            showLoaderDialog(
                                                                context);
                                                            await examDatabase
                                                                .updateQuestion(
                                                              widget.examId,
                                                              documentSnapshots
                                                                  .id,
                                                              {
                                                                "section":
                                                                    sections[
                                                                        index1],
                                                              },
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              icon: const Icon(Icons.edit),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Subject: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${docs['subject']}",
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                showLoaderDialog(context);
                                List<String> subjects = await examDatabase
                                    .getSubjectList(widget.examId);
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Select Subject"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 500,
                                                width: 500,
                                                child: ListView.builder(
                                                    itemCount: subjects.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index1) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ElevatedButton(
                                                          child: Text(
                                                            subjects[index1],
                                                          ),
                                                          onPressed: () async {
                                                            showLoaderDialog(
                                                                context);
                                                            await examDatabase
                                                                .updateQuestion(
                                                              widget.examId,
                                                              documentSnapshots
                                                                  .id,
                                                              {
                                                                "subject":
                                                                    subjects[
                                                                        index1],
                                                              },
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              icon: const Icon(Icons.edit),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                FilePickerResult? image =
                                    await FilePicker.platform.pickFiles();

                                if (image != null) {
                                  showLoaderDialog(context);
                                  final imageUrl = await ref
                                      .watch(storageProvider)
                                      .uploadImages(
                                        documentSnapshots.id,
                                        image,
                                        ref,
                                      );
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {
                                      "image_url": imageUrl,
                                    },
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Change Explanation Image"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: docs['image_url'] == null ||
                                      docs['image_url'] == ""
                                  ? const Icon(
                                      Icons.image_not_supported,
                                    )
                                  : const Icon(Icons.image),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                FilePickerResult? image =
                                    await FilePicker.platform.pickFiles();

                                if (image != null) {
                                  showLoaderDialog(context);
                                  final imageUrl = await ref
                                      .watch(storageProvider)
                                      .uploadQuestionImages(
                                        documentSnapshots.id,
                                        image,
                                        ref,
                                      );
                                  await examDatabase.updateQuestion(
                                    widget.examId,
                                    documentSnapshots.id,
                                    {
                                      "question_image_url": imageUrl,
                                    },
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Change Question Image"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: docs['question_image_url'] == null ||
                                      docs['question_image_url'] == ""
                                  ? const Icon(
                                      Icons.image_not_supported,
                                    )
                                  : const Icon(Icons.image),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      showLoaderDialog(context);
                      await examDatabase.deleteQuestion(
                        widget.examId,
                        documentSnapshots.id,
                      );
                      await ref.watch(storageProvider).deleteImage(
                            documentSnapshots.id,
                          );
                      await ref.watch(storageProvider).deleteQuestionImage(
                            documentSnapshots.id,
                          );
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _getEquationComponentsWidgets(String equation) {
    // explanation matter components
    final List<String> equationComponents = [];

    // flag whether we are extracting a simple word or the latex expression
    bool extractingWord = true;

    // temp string to hold the extracted words
    String tempString = '';

    // iterating through the string
    for (int i = 0; i < equation.length; i++) {
      // grabbing the current character
      String currentChar = equation[i];

      if (currentChar == '`') {
        if (extractingWord) {
          extractingWord = false;

          // if tempString is not empty then we add it to the list
          if (tempString.isNotEmpty) {
            equationComponents.add(tempString);
          }

          tempString = '';
          tempString += '`';
        } else {
          extractingWord = true;
          tempString += '`';
          equationComponents.add(tempString);
          tempString = '';
        }
      } else {
        tempString += currentChar;
      }
    }

    if (tempString.isNotEmpty) {
      equationComponents.add(tempString);
      tempString = '';
    }

    // list to hold the components widgets
    final List<Widget> componentsWidgets = equationComponents.map((component) {
      // if value is enclosed in ``, then we simply render it as Math tex
      if (component[0] == '`' && component[component.length - 1] == '`') {
        return FittedBox(
          child: Math.tex(component.replaceAll('`', '')),
        );
      }

      return Text(component);
    }).toList();

    return componentsWidgets;
  }
}

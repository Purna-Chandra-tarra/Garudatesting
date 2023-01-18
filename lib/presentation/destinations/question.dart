// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/domain/databases/exam_database.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

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

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ExamDatabase examDatabase = ref.watch(examDatabaseProvider);

    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 290,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Question',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                SizedBox(
                  width: 300,
                  child: TextField(
                    onEditingComplete: () {},
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Question',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height - 164,
              width: MediaQuery.of(context).size.width,
              child: PaginateFirestore(
                query: examDatabase.getQuestions(widget.examId, ref),
                isLive: true,
                itemBuilderType: PaginateBuilderType.listView,
                itemBuilder: ((context, documentSnapshots, index) {
                  final docs = documentSnapshots[index].data() as Map?;

                  if (searchController.text.isEmpty) {
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
                                  Text("Id: ${documentSnapshots[index].id}"),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          docs!['question'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Question",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            questionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "question":
                                                                questionController
                                                                    .text
                                                          },
                                                        );
                                                        questionController
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
                                        child: Math.tex(
                                            docs['question_equation'] ??
                                                "No Equation"),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Question Equation",
                                                  ),
                                                  content: Column(
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
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
                                        child: Text(
                                          "Option 1. ${docs['option_one']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 1",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            optionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "option_one":
                                                                optionController
                                                                    .text
                                                          },
                                                        );
                                                        optionController
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
                                        child: Math.tex(
                                          docs['option_one_equation'] ??
                                              "No Option 1 Equation",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 1 Equation",
                                                  ),
                                                  content: Column(
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
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
                                        child: Text(
                                          "Option 2. ${docs['option_two']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 2",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            optionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "option_two":
                                                                optionController
                                                                    .text
                                                          },
                                                        );
                                                        optionController
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
                                        child: Math.tex(
                                          docs['option_two_equation'] ??
                                              "No Option 2 Equation",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 2 Equation",
                                                  ),
                                                  content: Column(
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
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
                                        child: Text(
                                          "Option 3. ${docs['option_three']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 3",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            optionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "option_three":
                                                                optionController
                                                                    .text
                                                          },
                                                        );
                                                        optionController
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
                                        child: Math.tex(
                                          docs['option_three_equation'] ??
                                              "No Option 3 Equation",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 3 Equation",
                                                  ),
                                                  content: Column(
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
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
                                        child: Text(
                                          "Option 4. ${docs['option_four']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 4",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            optionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "option_four":
                                                                optionController
                                                                    .text
                                                          },
                                                        );
                                                        optionController
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
                                        child: Math.tex(
                                          docs['option_four_equation'] ??
                                              "No Option 4 Equation",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 4 Equation",
                                                  ),
                                                  content: Column(
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
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
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Answer: Option ${docs['answer']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Answer(1,2,3,4)",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            optionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "answer": int.parse(
                                                                optionController
                                                                    .text),
                                                          },
                                                        );
                                                        optionController
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
                                        child: Text(
                                          "Section: ${docs['section']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () async {
                                          showLoaderDialog(context);
                                          List<String> sections =
                                              await examDatabase.getSectionList(
                                                  widget.examId);
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Select Sections"),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 500,
                                                          width: 500,
                                                          child:
                                                              ListView.builder(
                                                                  itemCount:
                                                                      sections
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          ElevatedButton(
                                                                        child:
                                                                            Text(
                                                                          sections[
                                                                              index1],
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          showLoaderDialog(
                                                                              context);
                                                                          await examDatabase
                                                                              .updateQuestion(
                                                                            widget.examId,
                                                                            documentSnapshots[index].id,
                                                                            {
                                                                              "section": sections[index1],
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
                                        child: Text(
                                          "Subject: ${docs['subject']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () async {
                                          showLoaderDialog(context);
                                          List<String> subjects =
                                              await examDatabase.getSubjectList(
                                                  widget.examId);
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Select Subject"),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 500,
                                                          width: 500,
                                                          child:
                                                              ListView.builder(
                                                                  itemCount:
                                                                      subjects
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          ElevatedButton(
                                                                        child:
                                                                            Text(
                                                                          subjects[
                                                                              index1],
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          showLoaderDialog(
                                                                              context);
                                                                          await examDatabase
                                                                              .updateQuestion(
                                                                            widget.examId,
                                                                            documentSnapshots[index].id,
                                                                            {
                                                                              "subject": subjects[index1],
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
                                  ElevatedButton(
                                    onPressed: () async {
                                      showLoaderDialog(context);

                                      FilePickerResult? image =
                                          await FilePicker.platform.pickFiles();

                                      final imageUrl = await ref
                                          .watch(storageProvider)
                                          .uploadImages(
                                            documentSnapshots[index].id,
                                            image,
                                            ref,
                                          );
                                      await examDatabase.updateQuestion(
                                        widget.examId,
                                        documentSnapshots[index].id,
                                        {
                                          "image_url": imageUrl,
                                        },
                                      );
                                      Navigator.pop(context);
                                    },
                                    child:
                                        const Text("Change Explanation Image"),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                showLoaderDialog(context);
                                await examDatabase.deleteQuestion(
                                    widget.examId, documentSnapshots[index].id);
                                await ref
                                    .watch(storageProvider)
                                    .deleteImage(documentSnapshots[index].id);
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
                  } else if (docs!["question"]
                      .toString()
                      .toLowerCase()
                      .startsWith(
                        searchController.text.toLowerCase(),
                      )) {
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
                                  Text("Id: ${documentSnapshots[index].id}"),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          docs['question'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Question",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            questionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "question":
                                                                questionController
                                                                    .text
                                                          },
                                                        );
                                                        questionController
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
                                        child: Math.tex(
                                            docs['question_equation'] ??
                                                "No Equation"),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Question Equation",
                                                  ),
                                                  content: Column(
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
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
                                        child: Text(
                                          "Option 1. ${docs['option_one']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 1",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            optionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "option_one":
                                                                optionController
                                                                    .text
                                                          },
                                                        );
                                                        optionController
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
                                        child: Math.tex(
                                          docs['option_one_equation'] ??
                                              "No Option 1 Equation",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 1 Equation",
                                                  ),
                                                  content: Column(
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
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
                                        child: Text(
                                          "Option 2. ${docs['option_two']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 2",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            optionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "option_two":
                                                                optionController
                                                                    .text
                                                          },
                                                        );
                                                        optionController
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
                                        child: Math.tex(
                                          docs['option_two_equation'] ??
                                              "No Option 2 Equation",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 2 Equation",
                                                  ),
                                                  content: Column(
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
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
                                        child: Text(
                                          "Option 3. ${docs['option_three']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 3",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            optionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "option_three":
                                                                optionController
                                                                    .text
                                                          },
                                                        );
                                                        optionController
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
                                        child: Math.tex(
                                          docs['option_three_equation'] ??
                                              "No Option 3 Equation",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 3 Equation",
                                                  ),
                                                  content: Column(
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
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
                                        child: Text(
                                          "Option 4. ${docs['option_four']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 4",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            optionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "option_four":
                                                                optionController
                                                                    .text
                                                          },
                                                        );
                                                        optionController
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
                                        child: Math.tex(
                                          docs['option_four_equation'] ??
                                              "No Option 4 Equation",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Option 4 Equation",
                                                  ),
                                                  content: Column(
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
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
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Answer: Option ${docs['answer']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Update Answer(1,2,3,4)",
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            optionController,
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
                                                        showLoaderDialog(
                                                            context);
                                                        await examDatabase
                                                            .updateQuestion(
                                                          widget.examId,
                                                          documentSnapshots[
                                                                  index]
                                                              .id,
                                                          {
                                                            "answer": int.parse(
                                                                optionController
                                                                    .text),
                                                          },
                                                        );
                                                        optionController
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
                                        child: Text(
                                          "Section: ${docs['section']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () async {
                                          showLoaderDialog(context);
                                          List<String> sections =
                                              await examDatabase.getSectionList(
                                                  widget.examId);
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Select Sections"),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 500,
                                                          width: 500,
                                                          child:
                                                              ListView.builder(
                                                                  itemCount:
                                                                      sections
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          ElevatedButton(
                                                                        child:
                                                                            Text(
                                                                          sections[
                                                                              index1],
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          showLoaderDialog(
                                                                              context);
                                                                          await examDatabase
                                                                              .updateQuestion(
                                                                            widget.examId,
                                                                            documentSnapshots[index].id,
                                                                            {
                                                                              "section": sections[index1],
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
                                        child: Text(
                                          "Subject: ${docs['subject']}",
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () async {
                                          showLoaderDialog(context);
                                          List<String> subjects =
                                              await examDatabase.getSubjectList(
                                                  widget.examId);
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Select Subject"),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 500,
                                                          width: 500,
                                                          child:
                                                              ListView.builder(
                                                                  itemCount:
                                                                      subjects
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          ElevatedButton(
                                                                        child:
                                                                            Text(
                                                                          subjects[
                                                                              index1],
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          showLoaderDialog(
                                                                              context);
                                                                          await examDatabase
                                                                              .updateQuestion(
                                                                            widget.examId,
                                                                            documentSnapshots[index].id,
                                                                            {
                                                                              "subject": subjects[index1],
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
                                  ElevatedButton(
                                    onPressed: () async {
                                      showLoaderDialog(context);

                                      FilePickerResult? image =
                                          await FilePicker.platform.pickFiles();

                                      final imageUrl = await ref
                                          .watch(storageProvider)
                                          .uploadImages(
                                            documentSnapshots[index].id,
                                            image,
                                            ref,
                                          );
                                      await examDatabase.updateQuestion(
                                        widget.examId,
                                        documentSnapshots[index].id,
                                        {
                                          "image_url": imageUrl,
                                        },
                                      );
                                      Navigator.pop(context);
                                    },
                                    child:
                                        const Text("Change Explanation Image"),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                showLoaderDialog(context);
                                await examDatabase.deleteQuestion(
                                    widget.examId, documentSnapshots[index].id);
                                await ref
                                    .watch(storageProvider)
                                    .deleteImage(documentSnapshots[index].id);
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
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

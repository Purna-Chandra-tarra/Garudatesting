// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/domain/databases/exam_database.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';

import '../../providers/providers.dart';

class Question extends ConsumerWidget {
  Question({
    Key? key,
    required this.examId,
  }) : super(key: key);

  final String examId;
  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ExamDatabase examDatabase = ref.watch(examDatabaseProvider);

    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 320,
        child: ListView(
          children: [
            Text(
              'Question',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: examDatabase.getQuestions(examId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data.docs[index]
                                                ['question'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                                            Navigator.pop(
                                                                context);
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
                                                              examId,
                                                              snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id,
                                                              {
                                                                "question":
                                                                    questionController
                                                                        .text
                                                              },
                                                            );
                                                            questionController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
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
                                          Text(
                                            "Option 1. ${snapshot.data.docs[index]['option_one']}",
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
                                                            Navigator.pop(
                                                                context);
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
                                                              examId,
                                                              snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id,
                                                              {
                                                                "option_one":
                                                                    optionController
                                                                        .text
                                                              },
                                                            );
                                                            optionController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
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
                                          Text(
                                            "Option 2. ${snapshot.data.docs[index]['option_two']}",
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
                                                            Navigator.pop(
                                                                context);
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
                                                              examId,
                                                              snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id,
                                                              {
                                                                "option_two":
                                                                    optionController
                                                                        .text
                                                              },
                                                            );
                                                            optionController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
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
                                          Text(
                                            "Option 3. ${snapshot.data.docs[index]['option_three']}",
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
                                                            Navigator.pop(
                                                                context);
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
                                                              examId,
                                                              snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id,
                                                              {
                                                                "option_three":
                                                                    optionController
                                                                        .text
                                                              },
                                                            );
                                                            optionController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
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
                                          Text(
                                            "Option 4. ${snapshot.data.docs[index]['option_four']}",
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
                                                            Navigator.pop(
                                                                context);
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
                                                              examId,
                                                              snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id,
                                                              {
                                                                "option_four":
                                                                    optionController
                                                                        .text
                                                              },
                                                            );
                                                            optionController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
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
                                          Text(
                                            "Answer: Option ${snapshot.data.docs[index]['answer']}",
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
                                                            Navigator.pop(
                                                                context);
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
                                                              examId,
                                                              snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id,
                                                              {
                                                                "answer": int.parse(
                                                                    optionController
                                                                        .text),
                                                              },
                                                            );
                                                            optionController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
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
                                          Text(
                                            "Section: ${snapshot.data.docs[index]['section']}",
                                          ),
                                          const Spacer(),
                                          IconButton(
                                              onPressed: () async {
                                                showLoaderDialog(context);
                                                List<String> sections =
                                                    await examDatabase
                                                        .getSectionList(examId);

                                                String section = snapshot.data
                                                    .docs[index]['section'];
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                        title: const Text(
                                                            "Update Section"),
                                                        content: SizedBox(
                                                          height: 400,
                                                          width: 500,
                                                          child:
                                                              ListView.builder(
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ListTile(
                                                                leading: Radio<
                                                                    String>(
                                                                  value:
                                                                      sections[
                                                                          index],
                                                                  groupValue:
                                                                      section,
                                                                  onChanged:
                                                                      (value) {
                                                                    //TODO : FIX THIS
                                                                    //  examDatabase
                                                                    //     .updateQuestion(
                                                                    //   examId,
                                                                    //   snapshot
                                                                    //       .data
                                                                    //       .docs[index -
                                                                    //           1]
                                                                    //       .id,
                                                                    //   {
                                                                    //     "section":
                                                                    //         value.toString(),
                                                                    //   },
                                                                    // );
                                                                    // Navigator.pop(
                                                                    //     context);
                                                                  },
                                                                ),
                                                                title: Text(snapshot
                                                                            .data
                                                                            .docs[
                                                                        index][
                                                                    'section']),
                                                              );
                                                            },
                                                            itemCount:
                                                                sections.length,
                                                          ),
                                                        ));
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.edit))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Subject: ${snapshot.data.docs[index]['subject']}",
                                          ),
                                          const Spacer(),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.edit))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  } else {
                    return const CupertinoActivityIndicator();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

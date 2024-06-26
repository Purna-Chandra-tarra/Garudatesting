// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/domain/databases/exam_database.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

class ExamDetails extends ConsumerWidget {
  ExamDetails({Key? key, required this.examId}) : super(key: key);

  final String examId;
  final TextEditingController examTypeController = TextEditingController();

  final TextEditingController examDifficultyController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ExamDatabase examDatabase = ref.watch(examDatabaseProvider);
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 320,
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: ref.watch(examDatabaseProvider).getExam(examId),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData || snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exam Details',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Exam Name: "),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: Text(snapshot.data!['exam_name'])),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Exam Id: "),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(snapshot.data!['exam_id'].toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                      builder: (context, AsyncSnapshot snapshot1) {
                        if (snapshot1.hasData) {
                          if (snapshot1.data) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Exam Status:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: snapshot.data!['active']
                                              ? Colors.green[900]
                                              : Colors.red[800],
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            snapshot.data!['active']
                                                ? "ACTIVE"
                                                : 'INACTIVE',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    showLoaderDialog(context);
                                    await examDatabase.updateExamStatus(
                                      !snapshot.data!['active'],
                                      examId,
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Change Status"),
                                )
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const CupertinoActivityIndicator();
                        }
                      },
                      future: ref.watch(userDatabaseProvider).isSuperUser(
                            ref
                                .watch(authServiceProvider)
                                .user!
                                .email
                                .toString(),
                          ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Exam Type:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(snapshot.data!['type']),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Change Exam Type"),
                                  content: TextField(
                                    controller: examTypeController,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("Back"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text("Change"),
                                      onPressed: () async {
                                        showLoaderDialog(context);
                                        examDatabase.updateExamType(
                                          examTypeController.text,
                                          examId,
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text("Change Type"),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "No of Questions:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        FutureBuilder(
                          future: examDatabase.getExamLength(examId),
                          builder: ((context, AsyncSnapshot<int> snapshot) {
                            if (!snapshot.hasData) {
                              return const CupertinoActivityIndicator();
                            } else {
                              return Text(
                                "${snapshot.data}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Exam Difficulty:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(snapshot.data!['difficulty_level']),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Change Exam Difficulty"),
                                  content: TextField(
                                    controller: examDifficultyController,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("Back"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text("Change"),
                                      onPressed: () async {
                                        showLoaderDialog(context);
                                        examDatabase.updateDifficultyType(
                                          examDifficultyController.text,
                                          examId,
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text("Change Difficulty"),
                        )
                      ],
                    ),
                    FutureBuilder(
                      builder: (context, AsyncSnapshot snapshot1) {
                        if (snapshot1.hasData) {
                          if (snapshot1.data) {
                            return Row(
                              children: [
                                const Text(
                                  "Youtube:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Switch(
                                  value: snapshot.data!['youtube'],
                                  onChanged: (value) {
                                    examDatabase.updateYoutube(
                                      value,
                                      examId,
                                    );
                                  },
                                )
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const CupertinoActivityIndicator();
                        }
                      },
                      future: ref.watch(userDatabaseProvider).isSuperUser(
                            ref
                                .watch(authServiceProvider)
                                .user!
                                .email
                                .toString(),
                          ),
                    ),
                  ],
                );
              } else {
                return const CupertinoActivityIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

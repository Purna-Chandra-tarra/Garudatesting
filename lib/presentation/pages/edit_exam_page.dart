// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/destinations/exam_details.dart';
import 'package:garudaexams_dashboard/presentation/destinations/question.dart';
import 'package:garudaexams_dashboard/presentation/destinations/section.dart';
import 'package:garudaexams_dashboard/presentation/destinations/subject.dart';
import 'package:garudaexams_dashboard/presentation/destinations/subscription.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

import '../../domain/databases/exam_database.dart';

class EditExamPage extends ConsumerWidget {
  EditExamPage({
    Key? key,
    required this.examId,
  }) : super(key: key);

  final String examId;
  final TextEditingController subjectController = TextEditingController();

  final TextEditingController sectionController = TextEditingController();

  final TextEditingController periodController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  final TextEditingController featuresController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ExamDatabase examDatabase = ref.watch(examDatabaseProvider);
    return Scaffold(
      floatingActionButton: Builder(builder: (context) {
        switch (ref.watch(destinationExamProvider)) {
          case 0:
            return FloatingActionButton.extended(
              onPressed: () async {
                showLoaderDialog(context);
                await examDatabase.deleteExam(examId);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              label: const Text("Delete Exam"),
              icon: const Icon(Icons.delete),
            );
          case 1:
            return FloatingActionButton.extended(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Add Subject"),
                        content: Column(
                          children: [
                            TextField(
                              controller: subjectController,
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text("Add"),
                            onPressed: () async {
                              int random(int min, int max) {
                                return min + Random().nextInt(max - min);
                              }

                              showLoaderDialog(context);
                              await examDatabase.addExamSubject(
                                examId,
                                subjectController.text,
                                random(1000, 9000).toString(),
                              );
                              subjectController.clear();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
              label: const Text("Add Subject"),
              icon: const Icon(Icons.add),
            );
          case 2:
            return FloatingActionButton.extended(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Add Section"),
                        content: Column(
                          children: [
                            TextField(
                              controller: sectionController,
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text("Add"),
                            onPressed: () async {
                              int random(int min, int max) {
                                return min + Random().nextInt(max - min);
                              }

                              showLoaderDialog(context);
                              await examDatabase.addExamSection(
                                examId,
                                sectionController.text,
                                random(1000, 9000).toString(),
                              );
                              sectionController.clear();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
              label: const Text("Add Section"),
              icon: const Icon(Icons.add),
            );
          case 3:
            return FloatingActionButton.extended(
              onPressed: () {},
              label: const Text("Add Question"),
              icon: const Icon(Icons.add),
            );
          case 4:
            return FloatingActionButton.extended(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Add Subscription"),
                        content: SizedBox(
                          height: 500,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: amountController,
                                  decoration: const InputDecoration(
                                      helperText: "Amount"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: featuresController,
                                  decoration: const InputDecoration(
                                      helperText: "Features"),
                                  expands: true,
                                  maxLines: null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration: const InputDecoration(
                                      helperText: "Period"),
                                  controller: periodController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text("Add"),
                            onPressed: () async {
                              int random(int min, int max) {
                                return min + Random().nextInt(max - min);
                              }

                              showLoaderDialog(context);
                              await examDatabase.addSubscription(
                                amount: int.parse(amountController.text),
                                features: featuresController.text,
                                examId: examId,
                                id: random(1000000, 9000000).toString(),
                                period: int.parse(periodController.text),
                              );
                              sectionController.clear();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
              label: const Text("Add Subscription"),
              icon: const Icon(Icons.add),
            );
          default:
            return FloatingActionButton.extended(
              onPressed: () {},
              label: const Text("Save"),
              icon: const Icon(Icons.save),
            );
        }
      }),
      appBar: AppBar(
        title: const Text("Edit Exam"),
      ),
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (value) {
              ref.read(destinationExamProvider.state).state = value;
            },
            extended: true,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.abc_outlined),
                selectedIcon: Icon(Icons.abc_rounded),
                label: Text("Exam Details"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notes),
                selectedIcon: Icon(Icons.notes_rounded),
                label: Text("Subjects"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.insert_page_break_outlined),
                selectedIcon: Icon(Icons.insert_page_break_rounded),
                label: Text("Sections"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.question_mark_rounded),
                selectedIcon: Icon(Icons.question_mark_outlined),
                label: Text("Questions"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.diamond_outlined),
                selectedIcon: Icon(Icons.diamond_rounded),
                label: Text("Subscriptions"),
              ),
            ],
            selectedIndex: ref.watch(destinationExamProvider),
          ),
          Expanded(
            child: Builder(builder: (context) {
              switch (ref.watch(destinationExamProvider)) {
                case 0:
                  return ExamDetails(
                    examId: examId,
                  );
                case 1:
                  return Subject(
                    examId: examId,
                  );
                case 2:
                  return Section(
                    examId: examId,
                  );
                case 3:
                  return Question(
                    examId: examId,
                  );
                case 4:
                  return Subscription(
                    examId: examId,
                  );
                default:
                  return ExamDetails(
                    examId: examId,
                  );
              }
            }),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:file_picker/file_picker.dart';
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
import 'package:image_picker/image_picker.dart';

import '../../domain/databases/exam_database.dart';

class EditExamPage extends ConsumerStatefulWidget {
  const EditExamPage({
    Key? key,
    required this.examId,
  }) : super(key: key);

  final String examId;

  @override
  ConsumerState<EditExamPage> createState() => _EditExamPageState();
}

class _EditExamPageState extends ConsumerState<EditExamPage> {
  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  final TextEditingController subjectController = TextEditingController();

  final TextEditingController sectionController = TextEditingController();

  final TextEditingController periodController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  final TextEditingController featuresController = TextEditingController();

  late String section = "";

  late String subject = "";

  late String imageUrl = "";

  final TextEditingController questionController = TextEditingController();

  final TextEditingController option1Controller = TextEditingController();

  final TextEditingController option2Controller = TextEditingController();

  final TextEditingController option3Controller = TextEditingController();

  final TextEditingController option4Controller = TextEditingController();

  final TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ExamDatabase examDatabase = ref.watch(examDatabaseProvider);
    return Scaffold(
      floatingActionButton: Builder(builder: (context) {
        switch (ref.watch(destinationExamProvider)) {
          case 0:
            return FloatingActionButton.extended(
              onPressed: () async {
                showLoaderDialog(context);
                await examDatabase.deleteExam(widget.examId);
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
                                widget.examId,
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
                                widget.examId,
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
              onPressed: () {
                int id = random(100000, 900000);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Add Question"),
                        content: Column(
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                hintText: "Question",
                              ),
                              controller: questionController,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                hintText: "Option 1",
                              ),
                              controller: option1Controller,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                hintText: "Option 2",
                              ),
                              controller: option2Controller,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                hintText: "Option 3",
                              ),
                              controller: option3Controller,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                hintText: "Option 4",
                              ),
                              controller: option4Controller,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                hintText: "Answer",
                              ),
                              controller: answerController,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  List<String> sections = await examDatabase
                                      .getSectionList(widget.examId);
                                  Navigator.pop(context);
                                  section = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Select Section"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 500,
                                                width: 500,
                                                child: ListView.builder(
                                                    itemCount: sections.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ElevatedButton(
                                                          child: Text(
                                                            sections[index],
                                                          ),
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context,
                                                                sections[
                                                                    index]);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: const Text("Choose Section"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  List<String> sections = await examDatabase
                                      .getSubjectList(widget.examId);
                                  Navigator.pop(context);
                                  subject = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Select Subject"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 500,
                                                width: 500,
                                                child: ListView.builder(
                                                    itemCount: sections.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ElevatedButton(
                                                          child: Text(
                                                            sections[index],
                                                          ),
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context,
                                                                sections[
                                                                    index]);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: const Text("Choose Subject"),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  ImagePicker imagePicker = ImagePicker();
                                  FilePickerResult? image =
                                      await FilePicker.platform.pickFiles();
                                  showLoaderDialog(context);
                                  imageUrl = await ref
                                      .watch(storageProvider)
                                      .uploadImages(
                                        id.toString(),
                                        image,
                                        ref,
                                      );
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                    "Add Explanation (Only .png files allowed)")),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  await examDatabase.addQuestion(
                                      widget.examId, id.toString(), {
                                    "answer": int.parse(answerController.text),
                                    "option_one": option1Controller.text,
                                    "option_two": option2Controller.text,
                                    "option_three": option3Controller.text,
                                    "option_four": option4Controller.text,
                                    "question": questionController.text,
                                    "section": section,
                                    "subject": subject,
                                    "image_url": imageUrl,
                                  });
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text("Add Question"),
                              ),
                            )
                          ],
                        ),
                      );
                    });
              },
              label: const Text("Add Question"),
              icon: const Icon(Icons.add),
            );
          case 4:
            return FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Add Subscription"),
                        content: SizedBox(
                          width: 500,
                          height: 500,
                          child: Column(
                            children: [
                              //TODO Fix
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: amountController,
                                  decoration: const InputDecoration(
                                      helperText: "Amount"),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: featuresController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        helperText: "Features"),
                                    expands: true,
                                    maxLines: null,
                                  ),
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
                                examId: widget.examId,
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
                    examId: widget.examId,
                  );
                case 1:
                  return Subject(
                    examId: widget.examId,
                  );
                case 2:
                  return Section(
                    examId: widget.examId,
                  );
                case 3:
                  return Question(
                    examId: widget.examId,
                  );
                case 4:
                  return Subscription(
                    examId: widget.examId,
                  );
                default:
                  return ExamDetails(
                    examId: widget.examId,
                  );
              }
            }),
          )
        ],
      ),
    );
  }
}

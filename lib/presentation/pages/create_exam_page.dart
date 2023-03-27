// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/data/models/exam_model.dart';
import 'package:garudaexams_dashboard/domain/databases/exam_database.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

class CreateExamPage extends ConsumerWidget {
  CreateExamPage({Key? key}) : super(key: key);

  final TextEditingController examNameController = TextEditingController();
  final TextEditingController examTypeController = TextEditingController();
  final TextEditingController examDifficultyController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int random(int min, int max) {
      return min + Random().nextInt(max - min);
    }

    ExamDatabase examDatabase = ref.watch(examDatabaseProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showLoaderDialog(context);
          if (await examDatabase.addExam(
            Exam(
              examName: examNameController.text,
              difficulty: examDifficultyController.text,
              examId: random(10000000, 50000000),
              examType: examTypeController.text,
              active: false,
              youtube: false,
            ),
          )) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Error creating exam'),
                  actions: [
                    ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        label: const Text("Add Exam"),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Create Exam"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            TextField(
              controller: examNameController,
              decoration: const InputDecoration(
                labelText: "Exam Name",
              ),
            ),
            TextField(
              controller: examTypeController,
              decoration: const InputDecoration(
                labelText: "Exam Type",
              ),
            ),
            TextField(
              controller: examDifficultyController,
              decoration: const InputDecoration(
                labelText: "Difficulty Level",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

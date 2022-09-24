// ignore_for_file: use_build_context_synchronously

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
  const EditExamPage({
    Key? key,
    required this.examId,
  }) : super(key: key);

  final String examId;

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
              onPressed: () {},
              label: const Text("Add Subject"),
              icon: const Icon(Icons.add),
            );
          case 2:
            return FloatingActionButton.extended(
              onPressed: () {},
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
              onPressed: () {},
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
                icon: Icon(Icons.abc),
                label: Text("Exam Details"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notes),
                label: Text("Subjects"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.insert_page_break),
                label: Text("Sections"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.question_mark_rounded),
                label: Text("Questions"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.diamond_outlined),
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
                  return const Subject();
                case 2:
                  return const Section();
                case 3:
                  return const Question();
                case 4:
                  return const Subscription();
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

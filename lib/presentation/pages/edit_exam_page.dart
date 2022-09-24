import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditExamPage extends ConsumerWidget {
  const EditExamPage({
    Key? key,
    required this.examId,
  }) : super(key: key);

  final String examId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Exam"),
      ),
      body: Row(
        children: [
          NavigationRail(
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
            selectedIndex: 0,
          ),
          Expanded(
            child: Text(examId),
          )
        ],
      ),
    );
  }
}

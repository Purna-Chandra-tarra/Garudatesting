import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

class ExamDetails extends ConsumerWidget {
  const ExamDetails({Key? key, required this.examId}) : super(key: key);

  final String examId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 320,
        child: SingleChildScrollView(
            child: StreamBuilder(
                stream: ref.watch(examDatabaseProvider).getExam(examId),
                builder: (context, snapshot) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exam Details',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text("Exam Mode: "),
                          DropdownButton<bool>(items: const [
                            DropdownMenuItem(
                              child: Text("Active"),
                            ),
                            DropdownMenuItem(
                              child: Text("Inactive"),
                            ),
                          ], onChanged: (value) {})
                        ],
                      )
                    ],
                  );
                })),
      ),
    );
  }
}

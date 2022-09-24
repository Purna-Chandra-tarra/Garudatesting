// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';

import '../../domain/databases/exam_database.dart';
import '../../providers/providers.dart';

class Section extends ConsumerWidget {
  const Section({Key? key, required this.examId}) : super(key: key);

  final String examId;

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
              'Section',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: examDatabase.getSection(examId),
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
                                Text(snapshot.data.docs[index]['section']),
                                const Spacer(),
                                IconButton(
                                  onPressed: () async {
                                    showLoaderDialog(context);
                                    await examDatabase.deleteExamSection(
                                      examId,
                                      snapshot.data.docs[index].id,
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

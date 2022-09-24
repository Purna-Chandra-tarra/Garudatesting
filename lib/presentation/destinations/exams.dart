import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/domain/databases/exam_database.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

import '../pages/edit_exam_page.dart';

class Exams extends ConsumerWidget {
  const Exams({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ExamDatabase examDatabase = ref.watch(examDatabaseProvider);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width - 320,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exams',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditExamPage(
                                      examId: snapshot
                                          .data.docs[index]['exam_id']
                                          .toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    "Exam Name: ${snapshot.data.docs[index]['exam_name']}",
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            snapshot.data.docs[index]['type'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: snapshot.data.docs[index]
                                                  ['active']
                                              ? Colors.green[900]
                                              : Colors.red[800],
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            snapshot.data.docs[index]['active']
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
                                      const Spacer(),
                                    ],
                                  ),
                                  leading: Text(
                                    "#${snapshot.data.docs[index]['exam_id'].toString()}",
                                  ),
                                  trailing: FutureBuilder(
                                    future: examDatabase.getExamLength(snapshot
                                        .data.docs[index]['exam_id']
                                        .toString()),
                                    builder: ((context,
                                        AsyncSnapshot<int> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const CupertinoActivityIndicator();
                                      } else {
                                        return Text(
                                          "${snapshot.data} questions",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        );
                                      }
                                    }),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: snapshot.data.docs.length,
                        );
                      }
                    },
                    stream: examDatabase.getExamList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

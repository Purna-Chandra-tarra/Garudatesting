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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Section',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: examDatabase.getSection(examId),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CupertinoActivityIndicator();
              } else if (snapshot.hasData && snapshot.data.docs.isEmpty) {
                // If there are no documents in the snapshot, return a message or an empty container
                return const Center(
                  child: Text('No sections available.'),
                );
              } else if (snapshot.hasData) {
                List data = snapshot.data.docs;
                data.sort((a, b) {
                  return a['section']
                      .toLowerCase()
                      .compareTo(b['section'].toLowerCase());
                });
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
                              child: Text(
                                  '${index + 1}. ${data[index]['section']}'),
                            ),
                            const Spacer(),
                            FutureBuilder(
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString());
                                } else {
                                  return const CupertinoActivityIndicator();
                                }
                              },
                              future: ref
                                  .watch(examDatabaseProvider)
                                  .getSectionLength(
                                      examId, data[index]['section']),
                            ),
                            FutureBuilder(
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data) {
                                    return IconButton(
                                      onPressed: () {
                                        showLoaderDialog(context);
                                        try {
                                          examDatabase.deleteExamSection(
                                            examId,
                                            data[index].id,
                                          );
                                          Navigator.pop(context);
                                        } catch (e) {
                                          print('Error: $e');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Failed to delete section: $e'),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                } else {
                                  return Text('Error: ${snapshot.error}');
                                }
                              },
                              future:
                                  ref.watch(userDatabaseProvider).isSuperUser(
                                        ref
                                            .watch(authServiceProvider)
                                            .user!
                                            .email
                                            .toString(),
                                      ),
                            ),
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
          )
        ],
      ),
    );
  }
}

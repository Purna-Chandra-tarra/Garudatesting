// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';

import '../../domain/databases/exam_database.dart';
import '../../providers/providers.dart';

class Subject extends ConsumerWidget {
  const Subject({Key? key, required this.examId}) : super(key: key);

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
            'Subject',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: examDatabase.getSubject(examId),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(snapshot.data.docs[index]['name']),
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
                                    .getSubjectLength(examId,
                                        snapshot.data.docs[index]['name']),
                              ),
                              FutureBuilder(
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data) {
                                      return IconButton(
                                        onPressed: () async {
                                          showLoaderDialog(context);
                                          await examDatabase.deleteExamSubject(
                                            examId,
                                            snapshot.data.docs[index].id,
                                          );
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  } else {
                                    return const CupertinoActivityIndicator();
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
                  ),
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

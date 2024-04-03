// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
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
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 320,
        child: ListView(
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
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: examDatabase.getSubject(examId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CupertinoActivityIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      if (snapshot.hasData) {
                        final QuerySnapshot querySnapshot = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: ((context, index) {
                            final DocumentSnapshot docSnapshot =
                                querySnapshot.docs[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  children: [
                                    Text(docSnapshot['name']),
                                    const Spacer(),
                                    FutureBuilder(
                                      builder: (context,
                                          AsyncSnapshot<int> lengthSnapshot) {
                                        if (lengthSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CupertinoActivityIndicator();
                                        } else {
                                          // Handle the snapshot data to display additional information
                                          return Text(
                                              'Length: ${lengthSnapshot.data}');
                                        }
                                      },
                                      future: ref
                                          .watch(examDatabaseProvider)
                                          .getSubjectLength(
                                              examId, docSnapshot['name']),
                                    ),
                                    FutureBuilder(
                                      builder: (context,
                                          AsyncSnapshot<bool>
                                              permissionSnapshot) {
                                        if (permissionSnapshot
                                                .connectionState ==
                                            ConnectionState.waiting) {
                                          return const CupertinoActivityIndicator();
                                        } else {
                                          // Handle the snapshot data to determine user permissions
                                          return permissionSnapshot.data == true
                                              ? IconButton(
                                                  onPressed: () {
                                                    showLoaderDialog(context);
                                                    try {
                                                      examDatabase
                                                          .deleteExamSubject(
                                                        examId,
                                                        docSnapshot.id,
                                                      );
                                                      Navigator.pop(context);
                                                      // Refresh the stream after deleting content
                                                      ref.refresh(
                                                          examDatabaseProvider);
                                                    } catch (e) {
                                                      print('Error,$e');
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                  ),
                                                )
                                              : const SizedBox();
                                        }
                                      },
                                      future: ref
                                          .watch(userDatabaseProvider)
                                          .isSuperUser(
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
                        return const Center(
                          child: Text('No data available.'),
                        );
                      }
                    } else {
                      return const Center(
                        child: Text('Stream error occurred.'),
                      );
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}

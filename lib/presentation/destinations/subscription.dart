// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';

import '../../domain/databases/exam_database.dart';
import '../../providers/providers.dart';

class Subscription extends ConsumerWidget {
  const Subscription({Key? key, required this.examId}) : super(key: key);

  final String examId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ExamDatabase examDatabase = ref.watch(examDatabaseProvider);
    return Padding(
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
                'Subscription',
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
                  stream: examDatabase.getSubscription(examId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: ((context, index) {
                          return Card(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ListTile(
                                title: Text(
                                  "${snapshot.data.docs[index]["period"]} months",
                                ),
                                subtitle: Text(
                                  "Subscription Id# ${snapshot.data.docs[index]["id"]}",
                                ),
                                leading: Text(
                                  "Rs. ${snapshot.data.docs[index]["amount"]}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    showLoaderDialog(context);
                                    examDatabase.deleteSubscription(
                                        examId, snapshot.data.docs[index].id);
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Theme.of(context).colorScheme.error,
                                ),
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
      ),
    );
  }
}

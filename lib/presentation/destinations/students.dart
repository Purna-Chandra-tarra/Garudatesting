import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/domain/databases/user_database.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

class Students extends ConsumerWidget {
  const Students({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserDatabase userDatabase = ref.watch(userDatabaseProvider);
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Students',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          StreamBuilder(
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CupertinoActivityIndicator());
              } else {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 20),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          trailing: FilledButton(
                            onPressed: () async {
                              ref
                                  .read(userDatabaseProvider)
                                  .changeStudentStatus(
                                      snapshot.data?.docs[index]['phone_no']);
                            },
                            child: const Text("Reset"),
                          ),
                          title: Text(
                            "Student Name: ${snapshot.data?.docs[index]['name']}",
                          ),
                          subtitle: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: snapshot.data?.docs[index]
                                                ['device_id'] !=
                                            "error"
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      snapshot.data?.docs[index]['device_id'] !=
                                              "error"
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
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: SelectableText(
                                    snapshot.data?.docs[index]['phone_no'],
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
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data?.docs.length,
                  ),
                );
              }
            },
            stream: userDatabase.getUserList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

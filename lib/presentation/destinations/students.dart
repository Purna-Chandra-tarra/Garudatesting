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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 320,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Text(
                'Students',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else {
                      
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              trailing: FilledButton(
                                onPressed: () async {
                                  ref
                                      .read(userDatabaseProvider)
                                      .changeStudentStatus(snapshot
                                          .data?.docs[index]['phone_no']);
                                },
                                child: const Text("Reset"),
                              ),
                              title: Text(
                                "Student Name: ${snapshot.data?.docs[index]['name']}",
                              ),
                              subtitle: GestureDetector(
                                onTap: () async {
                                  String phoneNo = await snapshot
                                      .data?.docs[index]['phone_no'];
                                  await ref
                                      .watch(userDatabaseProvider)
                                      .changeStudentStatus(phoneNo);
                                },
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: snapshot.data?.docs[index]
                                                      ['device_id'] !=
                                                  "error"
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            snapshot.data?.docs[index]
                                                        ['device_id'] !=
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
                                    const SizedBox(width: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: SelectableText(
                                          snapshot.data?.docs[index]
                                              ['phone_no'],
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
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data?.docs.length,
                      );
                    }
                  },
                  stream: userDatabase.getUserList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/domain/databases/query_database.dart';
import 'package:garudaexams_dashboard/presentation/widgets/timestamp.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

class Queries extends ConsumerWidget {
  const Queries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    QueryDatabase queryDatabase = ref.watch(queryDatabaseProvider);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width - 320,
          child: ListView(
            children: [
              Text(
                'Queries',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Phone No. : ${snapshot.data.docs[index]['phone_no']}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const Divider(),
                                          Text(
                                            "Description: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            snapshot.data.docs[index]['query'],
                                          ),
                                          Text(
                                            readTimestamp(
                                              snapshot.data.docs[index]['date'],
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          )
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        queryDatabase.deleteQuery(
                                          snapshot.data.docs[index].id,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data.docs.length,
                      );
                    }
                  },
                  stream: queryDatabase.getQueryList(),
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

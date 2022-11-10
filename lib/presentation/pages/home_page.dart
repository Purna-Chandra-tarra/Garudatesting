// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/destinations/dashboard.dart';
import 'package:garudaexams_dashboard/presentation/destinations/exams.dart';
import 'package:garudaexams_dashboard/presentation/destinations/master_password.dart';
import 'package:garudaexams_dashboard/presentation/destinations/queries.dart';
import 'package:garudaexams_dashboard/presentation/destinations/students.dart';
import 'package:garudaexams_dashboard/presentation/pages/sign_in_page.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

import 'create_exam_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateExamPage(),
            ),
          );
        },
        label: const Text("Create Exam"),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Garuda Exams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text(e.toString()),
                        actions: [
                          ElevatedButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              }
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (value) =>
                ref.read(destinationProvider.state).state = value,
            extended: true,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: Text('Students'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notes_outlined),
                selectedIcon: Icon(Icons.notes_rounded),
                label: Text('Exams'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.warning_amber_rounded),
                selectedIcon: Icon(Icons.warning_rounded),
                label: Text('Queries'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.password_outlined),
                selectedIcon: Icon(Icons.password_rounded),
                label: Text('Master Password'),
              ),
            ],
            selectedIndex: ref.watch(destinationProvider),
          ),
          Builder(builder: (context) {
            switch (ref.watch(destinationProvider)) {
              case 0:
                return const Dashboard();
              case 1:
                return const Students();
              case 2:
                return const Exams();
              case 3:
                return const Queries();
              case 4:
                return  MasterPassword();
              default:
                return Container();
            }
          }),
        ],
      ),
    );
  }
}

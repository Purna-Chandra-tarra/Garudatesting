// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/destinations/dashboard.dart';
import 'package:garudaexams_dashboard/presentation/destinations/exams.dart';
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
                      return CupertinoAlertDialog(
                        title: const Text('Error'),
                        content: Text(e.toString()),
                        actions: [
                          CupertinoDialogAction(
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
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                selectedIcon: Icon(Icons.person),
                label: Text('Students'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notes),
                selectedIcon: Icon(Icons.notes),
                label: Text('Exams'),
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
              default:
                return Container();
            }
          }),
        ],
      ),
    );
  }
}

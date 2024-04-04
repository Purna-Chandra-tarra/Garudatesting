// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/destinations/about_us.dart';
import 'package:garudaexams_dashboard/presentation/destinations/dashboard.dart';
import 'package:garudaexams_dashboard/presentation/destinations/exams.dart';
import 'package:garudaexams_dashboard/presentation/destinations/master_password.dart';
import 'package:garudaexams_dashboard/presentation/destinations/queries.dart';
import 'package:garudaexams_dashboard/presentation/destinations/students.dart';
import 'package:garudaexams_dashboard/presentation/pages/loading_page.dart';
import 'package:garudaexams_dashboard/presentation/pages/sign_in_page.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

import 'create_exam_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final authService = ref.read(authServiceProvider);

    // updating the local user with the server user
    if (authService.user != null) {
      authService.user!.reload().then((value) {
        setState(() {
          isLoading = false;
        });

        // grabbing the user again
        final user = ref.read(authServiceProvider).user;

        // if user is null then we push the login
        if (user == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SignInPage(),
            ),
          );
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();

      // if user is null then we go to the login page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SignInPage(),
        ),
      );
    }
  }

  // pages
  final List<Widget> _pagesForSuperUser = [
    const Dashboard(),
    const Students(),
    const Exams(),
    const Queries(),
    MasterPassword(),
    const AboutUs(),
    Container(),
  ];

  final List<Widget> _pagesForNonSuperUser = [
    const Dashboard(),
    const Exams(),
    const AboutUs(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
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
          FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("SUPER USER"),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("NORMAL USER"),
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return const CupertinoActivityIndicator();
              }
            },
            future: ref.watch(userDatabaseProvider).isSuperUser(
                  ref.watch(authServiceProvider).user!.email.toString(),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: isLoading
                ? null
                : () async {
                    try {
                      await ref.read(authServiceProvider).signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignInPage()),
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
      body: isLoading
          ? const LoadingPage()
          : FutureBuilder(
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data) {
                    return Row(
                      children: [
                        if (!Platform.isAndroid)
                          NavigationRail(
                            onDestinationSelected: (value) => ref
                                .read(destinationProvider.state)
                                .state = value,
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
                              NavigationRailDestination(
                                icon: Icon(Icons.info_outline_rounded),
                                selectedIcon: Icon(Icons.info),
                                label: Text('About Us'),
                              ),
                            ],
                            selectedIndex: ref.watch(destinationProvider),
                          ),
                        Expanded(
                            child: _pagesForSuperUser[
                                ref.watch(destinationProvider)]),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        if (!Platform.isAndroid)
                          NavigationRail(
                            onDestinationSelected: (value) => ref
                                .read(destinationProvider.state)
                                .state = value,
                            extended: true,
                            destinations: const [
                              NavigationRailDestination(
                                icon: Icon(Icons.home_outlined),
                                selectedIcon: Icon(Icons.home_rounded),
                                label: Text('Dashboard'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.notes_outlined),
                                selectedIcon: Icon(Icons.notes_rounded),
                                label: Text('Exams'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.info_outline_rounded),
                                selectedIcon: Icon(Icons.info),
                                label: Text('About Us'),
                              ),
                            ],
                            selectedIndex: ref.watch(destinationProvider),
                          ),
                        Expanded(
                          child: _pagesForNonSuperUser[
                              ref.watch(destinationProvider)],
                        ),
                      ],
                    );
                  }
                } else {
                  return const Center(
                      child: CupertinoActivityIndicator(
                    radius: 50,
                  ));
                }
              },
              future: ref.watch(userDatabaseProvider).isSuperUser(
                    ref.watch(authServiceProvider).user!.email.toString(),
                  ),
            ),
      bottomNavigationBar: FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return NavigationBar(
                selectedIndex: ref.watch(destinationProvider),
                onDestinationSelected: (value) {
                  setState(() {
                    ref.read(destinationProvider.notifier).state = value;
                  });
                },
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.notes_outlined),
                    selectedIcon: Icon(Icons.notes_rounded),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.warning_amber_rounded),
                    selectedIcon: Icon(Icons.warning_rounded),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.password_outlined),
                    selectedIcon: Icon(Icons.password_rounded),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.info_outline_rounded),
                    selectedIcon: Icon(Icons.info),
                    label: '',
                  ),
                ],
              );
            } else {
              return NavigationBar(
                selectedIndex: ref.watch(destinationProvider),
                onDestinationSelected: (value) {
                  print('destination selected: $value');

                  setState(() {
                    ref.read(destinationProvider.notifier).state = value;
                  });
                },
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: 'Dashboard',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.notes_outlined),
                    selectedIcon: Icon(Icons.notes_rounded),
                    label: 'Exams',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.info_outline_rounded),
                    selectedIcon: Icon(Icons.info),
                    label: 'About Us',
                  ),
                ],
              );
            }
          } else {
            return const Center(
                child: CupertinoActivityIndicator(
              radius: 50,
            ));
          }
        },
        future: ref.watch(userDatabaseProvider).isSuperUser(
              ref.watch(authServiceProvider).user!.email.toString(),
            ),
      ),
    );
  }
}

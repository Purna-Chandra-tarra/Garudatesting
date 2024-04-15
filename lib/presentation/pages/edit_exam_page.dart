// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/destinations/exam_details.dart';
import 'package:garudaexams_dashboard/presentation/destinations/question.dart';
import 'package:garudaexams_dashboard/presentation/destinations/section.dart';
import 'package:garudaexams_dashboard/presentation/destinations/subject.dart';
import 'package:garudaexams_dashboard/presentation/destinations/subscription.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';
import 'package:garudaexams_dashboard/services/platform_service.dart';

import '../../domain/databases/exam_database.dart';

class EditExamPage extends ConsumerStatefulWidget {
  const EditExamPage({
    Key? key,
    required this.examId,
  }) : super(key: key);

  final String examId;

  @override
  ConsumerState<EditExamPage> createState() => _EditExamPageState();
}

class _EditExamPageState extends ConsumerState<EditExamPage> {
  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  final TextEditingController subjectController = TextEditingController();

  final TextEditingController sectionController = TextEditingController();

  final TextEditingController periodController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  final TextEditingController featuresController = TextEditingController();

  late String section = "";

  late String subject = "";

  late String imageUrl = "";

  late String optionimageUrl = "";

  late String option2imageUrl = "";

  late String option3imageUrl = "";

  late String option4imageUrl = "";

  late String questionImageUrl = "";

  final TextEditingController questionController = TextEditingController();

  final TextEditingController option1Controller = TextEditingController();

  final TextEditingController option2Controller = TextEditingController();

  final TextEditingController option3Controller = TextEditingController();

  final TextEditingController option4Controller = TextEditingController();

  final TextEditingController youtubeController = TextEditingController();

  final TextEditingController explanationMatterController =
      TextEditingController();

  final TextEditingController explanationHeadingController =
      TextEditingController();

  final TextEditingController questionEquationController =
      TextEditingController();

  final TextEditingController questionLevelController = TextEditingController();

  final TextEditingController option1EquationController =
      TextEditingController();

  final TextEditingController option2EquationController =
      TextEditingController();

  final TextEditingController option3EquationController =
      TextEditingController();

  final TextEditingController option4EquationController =
      TextEditingController();

  final TextEditingController answerController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  FilePickerResult? questionImage;

  FilePickerResult? image;

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    // pages
    final List<Widget> pagesForSuperUser = [
      ExamDetails(examId: widget.examId),
      Subject(
        examId: widget.examId,
      ),
      Section(
        examId: widget.examId,
      ),
      Question(
        examId: widget.examId,
      ),
      Subscription(
        examId: widget.examId,
      ),
    ];

    final List<Widget> pagesForNonSuperUsers = [
      ExamDetails(examId: widget.examId),
      Subject(examId: widget.examId),
      Section(examId: widget.examId),
      Question(examId: widget.examId),
    ];

    ExamDatabase examDatabase = ref.watch(examDatabaseProvider);
    return Scaffold(
      floatingActionButton: Builder(builder: (context) {
        switch (ref.watch(destinationExamProvider)) {
          case 0:
            return FloatingActionButton.extended(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Enter Password'),
                      content: TextField(
                        obscureText: true,
                        controller: passwordController,
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            showLoaderDialog(context);
                            if (await ref
                                    .watch(masterPasswordDatabaseProvider)
                                    .getPassword() ==
                                passwordController.text) {
                              await examDatabase.deleteExam(widget.examId);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Wrong Password'),
                                ),
                              );
                            }
                          },
                          child: const Text("Delete"),
                        )
                      ],
                    );
                  },
                );
              },
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              label: const Text("Delete Exam"),
              icon: const Icon(Icons.delete),
            );
          case 1:
            return FloatingActionButton.extended(
              onPressed: () {
                addSubjectDialog(context, examDatabase);
              },
              label: const Text("Add Subject"),
              icon: const Icon(Icons.add),
            );
          case 2:
            return FloatingActionButton.extended(
              onPressed: () {
                addSectionDialog(context, examDatabase);
              },
              label: const Text("Add Section"),
              icon: const Icon(Icons.add),
            );
          case 3:
            return FloatingActionButton.extended(
              onPressed: () {
                int id = random(100000, 900000);
                addQuestionDialog(context, examDatabase, id);

                setState(() {
                  errorMessage = null;
                });
              },
              label: const Text("Add Question"),
              icon: const Icon(Icons.add),
            );
          case 4:
            return FloatingActionButton.extended(
              onPressed: () {
                addSubscriptionDialog(context, examDatabase);
              },
              label: const Text("Add Subscription"),
              icon: const Icon(Icons.add),
            );
          default:
            return FloatingActionButton.extended(
              onPressed: () {},
              label: const Text("Save"),
              icon: const Icon(Icons.save),
            );
        }
      }),
      appBar: AppBar(
        title: const Text("Edit Exam"),
      ),
      body: FutureBuilder(
          future: ref.watch(userDatabaseProvider).isSuperUser(
                ref.watch(authServiceProvider).user!.email.toString(),
              ),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return Row(
                  children: [
                    if (!PlatformService.isMobile())
                      NavigationRail(
                        onDestinationSelected: (value) {
                          ref.read(destinationExamProvider.state).state = value;
                        },
                        extended: true,
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.abc_outlined),
                            selectedIcon: Icon(Icons.abc_rounded),
                            label: Text("Exam Details"),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.notes),
                            selectedIcon: Icon(Icons.notes_rounded),
                            label: Text("Subjects"),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.insert_page_break_outlined),
                            selectedIcon: Icon(Icons.insert_page_break_rounded),
                            label: Text("Sections"),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.question_mark_rounded),
                            selectedIcon: Icon(Icons.question_mark_outlined),
                            label: Text("Questions"),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.diamond_outlined),
                            selectedIcon: Icon(Icons.diamond_rounded),
                            label: Text("Subscriptions"),
                          ),
                        ],
                        selectedIndex: ref.watch(destinationExamProvider),
                      ),
                    Expanded(
                      child:
                          pagesForSuperUser[ref.watch(destinationExamProvider)],
                    )
                  ],
                );
              } else {
                return Row(
                  children: [
                    if (!PlatformService.isMobile())
                      NavigationRail(
                        onDestinationSelected: (value) {
                          ref.read(destinationExamProvider.state).state = value;
                        },
                        extended: true,
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.abc_outlined),
                            selectedIcon: Icon(Icons.abc_rounded),
                            label: Text("Exam Details"),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.notes),
                            selectedIcon: Icon(Icons.notes_rounded),
                            label: Text("Subjects"),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.insert_page_break_outlined),
                            selectedIcon: Icon(Icons.insert_page_break_rounded),
                            label: Text("Sections"),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.question_mark_rounded),
                            selectedIcon: Icon(Icons.question_mark_outlined),
                            label: Text("Questions"),
                          ),
                        ],
                        selectedIndex: ref.watch(destinationExamProvider),
                      ),
                    Expanded(
                      child: pagesForNonSuperUsers[
                          ref.watch(destinationExamProvider)],
                    )
                  ],
                );
              }
            } else {
              return const Center(
                  child: CupertinoActivityIndicator(
                radius: 50,
              ));
            }
          }),
      bottomNavigationBar: !PlatformService.isMobile()
          ? null
          : FutureBuilder(
              future: ref.watch(userDatabaseProvider).isSuperUser(
                    ref.watch(authServiceProvider).user!.email.toString(),
                  ),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data) {
                    return NavigationBar(
                      selectedIndex: ref.watch(destinationExamProvider),
                      onDestinationSelected: (value) {
                        setState(() {
                          ref.read(destinationExamProvider.notifier).state =
                              value;
                        });
                      },
                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysHide,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.abc_outlined),
                          selectedIcon: Icon(Icons.abc_rounded),
                          label: "Exam Details",
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.notes),
                          selectedIcon: Icon(Icons.notes_rounded),
                          label: "Subjects",
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.insert_page_break_outlined),
                          selectedIcon: Icon(Icons.insert_page_break_rounded),
                          label: "Sections",
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.question_mark_rounded),
                          selectedIcon: Icon(Icons.question_mark_outlined),
                          label: "Questions",
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.diamond_outlined),
                          selectedIcon: Icon(Icons.diamond_rounded),
                          label: "Subscriptions",
                        ),
                      ],
                    );
                  } else {
                    return NavigationBar(
                      selectedIndex: ref.watch(destinationExamProvider),
                      onDestinationSelected: (value) {
                        setState(() {
                          ref.read(destinationExamProvider.notifier).state =
                              value;
                        });
                      },
                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysHide,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.abc_outlined),
                          selectedIcon: Icon(Icons.abc_rounded),
                          label: "Exam Details",
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.notes),
                          selectedIcon: Icon(Icons.notes_rounded),
                          label: "Subjects",
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.insert_page_break_outlined),
                          selectedIcon: Icon(Icons.insert_page_break_rounded),
                          label: "Sections",
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.question_mark_rounded),
                          selectedIcon: Icon(Icons.question_mark_outlined),
                          label: "Questions",
                        ),
                      ],
                    );
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
    );
  }

  Future<dynamic> addSubscriptionDialog(
      BuildContext context, ExamDatabase examDatabase) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Subscription"),
            content: SizedBox(
              width: 500,
              height: 500,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: amountController,
                      decoration: const InputDecoration(helperText: "Amount"),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: featuresController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            helperText: "Features"),
                        expands: true,
                        maxLines: null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(helperText: "Period"),
                      controller: periodController,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text("Add"),
                onPressed: () async {
                  int random(int min, int max) {
                    return min + Random().nextInt(max - min);
                  }

                  showLoaderDialog(context);
                  await examDatabase.addSubscription(
                    amount: int.parse(amountController.text),
                    features: featuresController.text,
                    examId: widget.examId,
                    id: random(1000000, 9000000).toString(),
                    period: int.parse(periodController.text),
                  );
                  sectionController.clear();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<dynamic> addQuestionDialog(
      BuildContext context, ExamDatabase examDatabase, int id) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text("Add Question"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    if (errorMessage != null)
                      Text(
                        errorMessage.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Question",
                      ),
                      controller: questionController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Question Equation",
                      ),
                      controller: questionEquationController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Question Level",
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: questionLevelController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Option 1",
                      ),
                      controller: option1Controller,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Option 1 Equation",
                      ),
                      controller: option1EquationController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          image = await FilePicker.platform.pickFiles();

                          // if image is not null, we upload it
                          if (image != null) {
                            showLoaderDialog(context);

                            // Append a suffix to the ID for option 2
                            String optionImageId = id.toString() + "_option1";

                            // Upload the image with the modified ID
                            optionimageUrl = await ref
                                .watch(storageProvider)
                                .uploadOptionImage(
                                  optionImageId,
                                  image,
                                  ref,
                                );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Text("Add option1 Image"),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Option 2",
                      ),
                      controller: option2Controller,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Option 2 equation",
                      ),
                      controller: option2EquationController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          image = await FilePicker.platform.pickFiles();

                          // if image is not null, we upload it
                          if (image != null) {
                            showLoaderDialog(context);

                            // Append a suffix to the ID for option 2
                            String option2ImageId = id.toString() + "_option2";

                            // Upload the image with the modified ID
                            option2imageUrl = await ref
                                .watch(storageProvider)
                                .uploadOptionImage(
                                  option2ImageId,
                                  image,
                                  ref,
                                );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Text("Add option2 Image"),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Option 3",
                      ),
                      controller: option3Controller,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Option 3 Equation",
                      ),
                      controller: option3EquationController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          image = await FilePicker.platform.pickFiles();

                          // if image is not null, we upload it
                          if (image != null) {
                            showLoaderDialog(context);

                            // Append a suffix to the ID for option 2
                            String option3ImageId = id.toString() + "_option3";

                            // Upload the image with the modified ID
                            option3imageUrl = await ref
                                .watch(storageProvider)
                                .uploadOptionImage(
                                  option3ImageId,
                                  image,
                                  ref,
                                );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Text("Add option3 Image"),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Option 4",
                      ),
                      controller: option4Controller,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Option 4 Equation",
                      ),
                      controller: option4EquationController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          image = await FilePicker.platform.pickFiles();

                          // if image is not null, we upload it
                          if (image != null) {
                            showLoaderDialog(context);

                            // Append a suffix to the ID for option 2
                            String option4ImageId = id.toString() + "_option4";

                            // Upload the image with the modified ID
                            option4imageUrl = await ref
                                .watch(storageProvider)
                                .uploadOptionImage(
                                  option4ImageId,
                                  image,
                                  ref,
                                );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Text("Add option4 Image"),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Answer",
                      ),
                      keyboardType: TextInputType.number,
                      controller: answerController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        // if there is some value then we set the error message to null
                        if (value.isNotEmpty) {
                          setState(() {
                            errorMessage = null;
                          });
                        }
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Youtube Link",
                      ),
                      controller: youtubeController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Explanation Heading",
                      ),
                      controller: explanationHeadingController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Explanation Matter",
                      ),
                      minLines: 5,
                      maxLines: 10,
                      controller: explanationMatterController,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          showLoaderDialog(context);
                          List<String> sections =
                              await examDatabase.getSectionList(widget.examId);
                          sections.sort((a, b) => a.toLowerCase().compareTo(b
                              .toLowerCase())); // Sort the sections alphabetically
                          Navigator.pop(context);
                          section = await showDialog(
                            context: context,
                            builder: (context) {
                              String searchQuery =
                                  ''; // Initialize search query
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text("Select Section"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Search Section',
                                            prefixIcon: Icon(Icons.search),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              searchQuery = value.toLowerCase();
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          height: 500,
                                          width: 500,
                                          child: ListView.builder(
                                              itemCount: sections.length,
                                              shrinkWrap: true,
                                              // ignore: body_might_complete_normally_nullable
                                              itemBuilder: (context, index) {
                                                final sectionName =
                                                    sections[index]
                                                        .toLowerCase();
                                                if (sectionName
                                                    .contains(searchQuery)) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ElevatedButton(
                                                      // child:
                                                      //     Text(sections[index]),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              '${index + 1}. ${sections[index]}'),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          FutureBuilder(
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                return Text(snapshot
                                                                    .data
                                                                    .toString());
                                                              } else {
                                                                return const CupertinoActivityIndicator();
                                                              }
                                                            },
                                                            future: ref
                                                                .watch(
                                                                    examDatabaseProvider)
                                                                .getSectionLength(
                                                                  widget.examId,
                                                                  sections[
                                                                      index],
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.pop(
                                                          context,
                                                          sections[index],
                                                        );
                                                      },
                                                    ),
                                                  );
                                                } else {
                                                  return Container(); // Empty container if section doesn't match search query
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        },
                        child: const Text("Choose Section"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          showLoaderDialog(context);
                          List<String> sections =
                              await examDatabase.getSubjectList(widget.examId);
                          sections.sort((a, b) => a.toLowerCase().compareTo(b
                              .toLowerCase())); // Sort the subjects alphabetically
                          Navigator.pop(context);
                          subject = await showDialog(
                            context: context,
                            builder: (context) {
                              String searchQuery =
                                  ''; // Initialize search query
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Text("Select Subject"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Search Subject',
                                              prefixIcon: Icon(Icons.search),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                searchQuery =
                                                    value.toLowerCase();
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: 500,
                                            width: 500,
                                            child: ListView.builder(
                                              itemCount: sections.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                final subjectName =
                                                    sections[index]
                                                        .toLowerCase();
                                                if (subjectName
                                                    .contains(searchQuery)) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ElevatedButton(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              '${index + 1}. ${sections[index]}'),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          FutureBuilder(
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                return Text(snapshot
                                                                    .data
                                                                    .toString());
                                                              } else {
                                                                return const CupertinoActivityIndicator();
                                                              }
                                                            },
                                                            future: ref
                                                                .watch(
                                                                    examDatabaseProvider)
                                                                .getSubjectLength(
                                                                  widget.examId,
                                                                  sections[
                                                                      index],
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.pop(context,
                                                            sections[index]);
                                                      },
                                                    ),
                                                  );
                                                } else {
                                                  // Return an empty container if subject doesn't match search query
                                                  return Container();
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: const Text("Choose Subject"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          image = await FilePicker.platform.pickFiles();

                          // if image is not null, we upload it
                          if (image != null) {
                            showLoaderDialog(context);
                            imageUrl =
                                await ref.watch(storageProvider).uploadImages(
                                      id.toString(),
                                      image,
                                      ref,
                                    );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Text("Add Explanation Image"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          questionImage = await FilePicker.platform.pickFiles();

                          // if question image is not null, we upload it
                          if (questionImage != null) {
                            showLoaderDialog(context);
                            questionImageUrl = await ref
                                .watch(storageProvider)
                                .uploadQuestionImages(
                                  id.toString(),
                                  questionImage,
                                  ref,
                                );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Text("Add Question Image"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // if the image and the question image are null, we show an error message accordingly
                          if (answerController.text.isEmpty) {
                            setState(() {
                              errorMessage = 'Answer can not be empty.';
                            });
                            return;
                          }

                          setState(() {
                            errorMessage = null;
                          });

                          showLoaderDialog(context);
                          await examDatabase
                              .addQuestion(widget.examId, id.toString(), {
                            "answer": int.parse(answerController.text),
                            "option_one": option1Controller.text,
                            "option_image_url": optionimageUrl,
                            "option_two": option2Controller.text,
                            "option2_image_url": option2imageUrl,
                            "option_three": option3Controller.text,
                            "option3_image_url": option3imageUrl,
                            "option_four": option4Controller.text,
                            "option4_image_url": option4imageUrl,
                            "question": questionController.text,
                            "level": int.parse(questionLevelController.text),
                            "option_one_equation":
                                option1EquationController.text,
                            "option_two_equation":
                                option2EquationController.text,
                            "option_three_equation":
                                option3EquationController.text,
                            "option_four_equation":
                                option4EquationController.text,
                            "question_equation":
                                questionEquationController.text,
                            "section": section,
                            "subject": subject,
                            "image_url": imageUrl,
                            "question_image_url": questionImageUrl,
                            "date_added": Timestamp.fromDate(
                              DateTime.now(),
                            ),
                            "youtube_link": youtubeController.text,
                            "explanation_matter":
                                explanationMatterController.text,
                            "explanation_heading":
                                explanationHeadingController.text,
                          });
                          answerController.clear();
                          option1Controller.clear();
                          option2Controller.clear();
                          option3Controller.clear();
                          option4Controller.clear();
                          option1EquationController.clear();
                          option2EquationController.clear();
                          option3EquationController.clear();
                          option4EquationController.clear();
                          youtubeController.clear();
                          explanationMatterController.clear();
                          explanationHeadingController.clear();
                          questionController.clear();
                          questionEquationController.clear();
                          questionLevelController.clear();
                          optionimageUrl = "";
                          option2imageUrl = "";
                          option3imageUrl = "";
                          option4imageUrl = "";
                          imageUrl = "";
                          section = "";
                          subject = "";
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Add Question"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> addSectionDialog(
      BuildContext context, ExamDatabase examDatabase) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Section"),
            content: Column(
              children: [
                TextField(
                  controller: sectionController,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text("Add"),
                onPressed: () async {
                  int random(int min, int max) {
                    return min + Random().nextInt(max - min);
                  }

                  showLoaderDialog(context);
                  await examDatabase.addExamSection(
                    widget.examId,
                    sectionController.text,
                    random(1000, 9000).toString(),
                  );
                  sectionController.clear();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<dynamic> addSubjectDialog(
      BuildContext context, ExamDatabase examDatabase) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Subject"),
            content: Column(
              children: [
                TextField(
                  controller: subjectController,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text("Add"),
                onPressed: () async {
                  int random(int min, int max) {
                    return min + Random().nextInt(max - min);
                  }

                  showLoaderDialog(context);
                  await examDatabase.addExamSubject(
                    widget.examId,
                    subjectController.text,
                    random(1000, 9000).toString(),
                  );
                  subjectController.clear();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

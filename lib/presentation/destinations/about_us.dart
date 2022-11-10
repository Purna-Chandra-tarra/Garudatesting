// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

class AboutUs extends ConsumerWidget {
  AboutUs({super.key});

  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 320,
        child: GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Update Account Password'),
                  content: TextField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new password',
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            showLoaderDialog(context);
                            await ref
                                .watch(authServiceProvider)
                                .user!
                                .updatePassword(_newPasswordController.text);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Success"),
                              ),
                            );
                          } catch (e) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        },
                        child: const Text("Submit"))
                  ],
                );
              },
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "About Us\n\nOur mission is to make digital education in the form of MCQ questios to reachable to everyone. Providing help to the students, employees, and who are in the phase of learning and chase of getting a government or other reputed jobs or improving their knowledge as per their requirements.Resources are for all, available equally. Got a question making you trouble? Well, leave all the troubles for our expert and simply post your question to us. Your question will be answered either by experts or users or both.Yes, our aim is to provide all study material you need for your preparation, in different subscription plans. Even you can clear your doubt by asking questions.As our name is Garuda Exams it clears our vision in itself. Garuda is the God of Strength and Vigilance and he Gives freedom from slavery. Therefore, our team is here to cater to you with all information, study materials, suggestions, sample papers and many more at very one place. Thus, we are on the way to support you to reach your goals for any kind of exams.We are concerned with reading, learning, teaching and helping in a very simple mean of internet. And we are doing it in a very friendly way at all levels."),
          ),
        ),
      ),
    );
  }
}

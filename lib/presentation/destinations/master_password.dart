// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garudaexams_dashboard/presentation/widgets/loader_dialog.dart';
import 'package:garudaexams_dashboard/providers/providers.dart';

class MasterPassword extends ConsumerWidget {
  MasterPassword({super.key});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController oldpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 320,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Change Master Password'),
              TextField(
                controller: oldpasswordController,
                decoration: const InputDecoration(
                  hintText: 'Enter old password',
                ),
              ),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Enter new password',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    showLoaderDialog(context);
                    if (await ref
                            .watch(masterPasswordDatabaseProvider)
                            .getPassword() ==
                        oldpasswordController.text) {
                      await ref
                          .watch(masterPasswordDatabaseProvider)
                          .updatePassword(
                            password: newPasswordController.text,
                          );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Success"),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Wrong Password'),
                        ),
                      );
                    }
                  },
                  child: const Text("Change password"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

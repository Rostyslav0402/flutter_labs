import 'package:flutter/material.dart';

void showNoInternetDialog(BuildContext context) {
  // ignore: inference_failure_on_function_invocation
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('No internet '),
        content: const Text(
          'try later',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

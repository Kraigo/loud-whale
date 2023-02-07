
import 'package:flutter/material.dart';

class PromptDialog extends StatefulWidget {
  const PromptDialog({super.key});

  @override
  State<PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<PromptDialog> {
  late TextEditingController _textFieldController;
  
  @override
  void initState() {
    _textFieldController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return AlertDialog(
          title: const Text('Enter auth token'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Token"),
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context, _textFieldController.text);
              },
            ),
          ],
        );
  }
}

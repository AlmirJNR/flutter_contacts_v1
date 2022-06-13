import 'package:flutter/material.dart';

class NotesTextFormFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;

  const NotesTextFormFieldWidget({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: textEditingController,
      maxLength: 100,
      maxLines: 2,
      decoration: const InputDecoration(
        labelText: 'Notes',
        border: OutlineInputBorder(),
      ),
    );
  }
}

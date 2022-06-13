import 'package:flutter/material.dart';

class EmailTextFormFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;

  const EmailTextFormFieldWidget({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: textEditingController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Enter an email';
        }

        if (!RegExp(r"^[A-Za-z0-9+_.-]+@[A-Za-z0-9+_.-]+$").hasMatch(value)) {
          return 'Enter a valid email';
        }

        return null;
      },
    );
  }
}

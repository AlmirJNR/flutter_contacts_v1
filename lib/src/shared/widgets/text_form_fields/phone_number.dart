import 'package:flutter/material.dart';

class PhoneNumberTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final int index;

  const PhoneNumberTextFormField({
    Key? key,
    required this.textEditingController,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: 'Phone number ${index + 1}',
        border: const OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Enter a phone number';
        }

        return null;
      },
    );
  }
}

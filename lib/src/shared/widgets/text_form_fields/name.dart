import 'package:flutter/material.dart';

class NameTextFormFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;

  const NameTextFormFieldWidget({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: textEditingController,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Enter a name';
        }

        return null;
      },
    );
  }
}

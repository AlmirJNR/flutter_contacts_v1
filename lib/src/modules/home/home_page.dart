import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/src/modules/home/widgets/contact_list.dart';
import 'package:flutter_contacts_v1/src/modules/home/widgets/floating_add_contact_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Contacts V1')),
      body: const ContactListWidget(),
      floatingActionButton: const FloatingAddContactButtonWidget(buttonSize: 64),
    );
  }
}

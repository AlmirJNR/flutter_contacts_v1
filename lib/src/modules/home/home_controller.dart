import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/src/shared/contact_model.dart';
import 'package:flutter_contacts_v1/src/shared/database_client.dart';

// import '../../mock/contacts_mock_data.dart';

class HomeController extends ChangeNotifier {
  final DatabaseClient databaseClient;
  List<ContactModel> contacts = <ContactModel>[];

  HomeController({required this.databaseClient}) {
    _init();
  }

  Future<void> _init() async {
    contacts.addAll(await databaseClient.readContacts());

    // init mocked users
    // for (var map in mockedData) {
    //   contacts.add(ContactModel.fromMap(map));
    // }

    notifyListeners();
  }

  Future<void> updateContactsList() async {
    contacts = await databaseClient.readContacts();

    notifyListeners();
  }
}

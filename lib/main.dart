import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/flutter_contacts_app_v1.dart';
import 'package:flutter_contacts_v1/src/shared/database_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseClient databaseClient = DatabaseClient();
  await databaseClient.initDatabase();

  runApp(
    FlutterContactsAppV1(
      databaseClient: databaseClient,
    ),
  );
}

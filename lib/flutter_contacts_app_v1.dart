import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/src/modules/home/home_controller.dart';
import 'package:flutter_contacts_v1/src/shared/database_client.dart';
import 'package:provider/provider.dart';

import 'src/modules/home/home_page.dart';

class FlutterContactsAppV1 extends StatelessWidget {
  final DatabaseClient databaseClient;

  const FlutterContactsAppV1({
    Key? key,
    required this.databaseClient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseClient>(create: (context) => databaseClient, lazy: false),
        ListenableProvider<HomeController>(create: (context) => HomeController(databaseClient: context.read<DatabaseClient>())),
      ],
      child: MaterialApp(
        title: 'Flutter Contacts V1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
          ),
          bottomAppBarTheme: const BottomAppBarTheme(
            color: Colors.blue,
            elevation: 1,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.blue,
            selectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.blue,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter_contacts_v1/src/shared/constants.dart';
import 'package:flutter_contacts_v1/src/shared/contact_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum DatabaseSituation { disabled, initializing, error, enabled }

class DatabaseClient {
  late final Database _database;
  DatabaseSituation _databaseSituation = DatabaseSituation.disabled;

  DatabaseClient() {
    log('Database is pending initialization');
  }

  Future<void> initDatabase() async {
    if (_databaseSituation == DatabaseSituation.enabled) {
      log('Database is already initialized');
      return;
    }

    _databaseSituation = DatabaseSituation.initializing;
    log('Database is initializing');

    try {
      String _databasesPath = await getDatabasesPath();
      String _path = join(_databasesPath, kDatabaseName);

      _database = await openDatabase(
        _path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''CREATE TABLE $kTableName (
            $kIdColumn INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $kProfilePictureColumn TEXT,
            $kProfileImageTypeColumn TEXT,
            $kNameColumn TEXT NOT NULL,
            $kPhoneNumbersColumn TEXT,
            $kEmailColumn TEXT,
            $kNotesColumn TEXT
          )''');
        },
      );

      _databaseSituation = DatabaseSituation.enabled;
      log('Database was initialized');
    } catch (error) {
      _databaseSituation = DatabaseSituation.error;
      log('$_databaseSituation', error: error);
    }
  }

  Future<int?> createContact(ContactModel contactModel) async {
    if (_databaseSituation == DatabaseSituation.enabled) {
      return await _database.insert(kTableName, contactModel.toMap());
    }

    return null;
  }

  Future<List<ContactModel>> readContacts() async {
    List<ContactModel> contacts = <ContactModel>[];

    if (_databaseSituation == DatabaseSituation.enabled) {
      List<Map<String, dynamic>> databaseResponse = await _database.query(kTableName, orderBy: kIdColumn);

      for (Map<String, dynamic> element in databaseResponse) {
        contacts.add(ContactModel.fromMap(element));
      }
    }

    return contacts;
  }

  Future<void> updateContact(ContactModel contactModel) async {
    if (_databaseSituation == DatabaseSituation.enabled) {
      await _database.update(
        kTableName,
        contactModel.toMap(),
        where: '$kIdColumn = ?',
        whereArgs: [contactModel.id],
      );
    }
  }

  Future<void> deleteContact(ContactModel contactModel) async {
    if (_databaseSituation == DatabaseSituation.enabled) {
      await _database.delete(
        kTableName,
        where: '$kIdColumn = ?',
        whereArgs: [contactModel.id],
      );
    }
  }
}

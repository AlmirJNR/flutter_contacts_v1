import 'package:flutter_contacts_v1/src/shared/enum_profile_image_type.dart';

class ContactModel {
  int? id;
  String profilePicture = '';
  ProfileImageType? profileImageType;
  String name = '';
  List<String> phoneNumbers = <String>[];
  String email = '';
  String notes = '';

  ContactModel();

  ContactModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    profilePicture = map['profilePicture'];
    switch (map['profileImageType']) {
      case 'url':
        profileImageType = ProfileImageType.url;
        break;
      case 'camera':
        profileImageType = ProfileImageType.camera;
        break;
      case 'gallery':
        profileImageType = ProfileImageType.gallery;
        break;
    }
    name = map['name'];
    phoneNumbers = (map['phoneNumbers'] as String).split(',');
    email = map['email'];
    notes = map['notes'];
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'profilePicture': profilePicture,
        'profileImageType': profileImageType?.name,
        'name': name,
        'phoneNumbers': phoneNumbers.toString().replaceAll(RegExp(r'\[*\]*'), ''),
        'email': email,
        'notes': notes,
      };

  @override
  String toString() => 'Contact($id $name $email)';
}

import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/src/shared/contact_model.dart';
import 'package:flutter_contacts_v1/src/shared/database_client.dart';
import 'package:flutter_contacts_v1/src/shared/enum_profile_image_type.dart';
import 'package:flutter_contacts_v1/src/shared/interfaces/select_profile_image.dart';
import 'package:image_picker/image_picker.dart';

class EditContactController extends ChangeNotifier implements ISelectProfileImage {
  final DatabaseClient databaseClient;

  final ImagePicker _imagePicker = ImagePicker();

  EditContactController({required this.databaseClient});

  @override
  ValueNotifier<ProfileImageType?> profileImageType = ValueNotifier(null);

  @override
  void selectUrlImage() {
    profileImageType.value = ProfileImageType.url;
  }

  @override
  void setUrlImage(ContactModel contact, String imageUrl) {
    contact.profilePicture = imageUrl;
    contact.profileImageType = ProfileImageType.url;
    notifyListeners();
  }

  @override
  void setGalleryImage(ContactModel contact) async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    contact.profilePicture = image.path;
    contact.profileImageType = ProfileImageType.gallery;
    profileImageType.value = ProfileImageType.gallery;
    notifyListeners();
  }

  @override
  void setCameraImage(ContactModel contact) async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    contact.profilePicture = image.path;
    contact.profileImageType = ProfileImageType.camera;
    profileImageType.value = ProfileImageType.camera;
    notifyListeners();
  }

  void updateContact(
    GlobalKey<FormState> formKey, {
    required ContactModel contact,
    required TextEditingController textNameController,
    required TextEditingController textEmailController,
    required List<TextEditingController> textPhoneNumberControllers,
    required TextEditingController textNotesController,
  }) {
    if (!(formKey.currentState?.validate() ?? false)) return;

    contact.name = textNameController.text;
    contact.email = textEmailController.text;

    for (int i = 0; i < textPhoneNumberControllers.length; i++) {
      contact.phoneNumbers[i] = textPhoneNumberControllers[i].text;
    }

    contact.notes = textNotesController.text;

    databaseClient.updateContact(contact);
    notifyListeners();
  }
}

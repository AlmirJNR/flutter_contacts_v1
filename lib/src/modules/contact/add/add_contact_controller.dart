import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/src/modules/home/home_controller.dart';
import 'package:flutter_contacts_v1/src/shared/database_client.dart';
import 'package:flutter_contacts_v1/src/shared/enum_profile_image_type.dart';
import 'package:flutter_contacts_v1/src/shared/contact_model.dart';
import 'package:flutter_contacts_v1/src/shared/interfaces/select_profile_image.dart';
import 'package:image_picker/image_picker.dart';

class AddContactController extends ChangeNotifier implements ISelectProfileImage {
  final DatabaseClient databaseClient;
  final HomeController homeController;
  final ImagePicker _imagePicker = ImagePicker();

  AddContactController({
    required this.databaseClient,
    required this.homeController,
  });

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
  Future<void> setCameraImage(ContactModel contact) async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    contact.profilePicture = image.path;
    contact.profileImageType = ProfileImageType.camera;
    profileImageType.value = ProfileImageType.camera;
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

  void createContact(
    GlobalKey<FormState> formKey, {
    required ContactModel contact,
    required TextEditingController textNameController,
    required TextEditingController textEmailController,
    required List<TextEditingController> textPhoneNumberControllers,
    required TextEditingController textNotesController,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    contact.name = textNameController.text;
    contact.email = textEmailController.text;

    for (int i = 0; i < textPhoneNumberControllers.length; i++) {
      contact.phoneNumbers.add(textPhoneNumberControllers[i].text);
    }

    contact.notes = textNotesController.text;

    contact.id = await databaseClient.createContact(contact);
    await homeController.updateContactsList();
    notifyListeners();
  }
}

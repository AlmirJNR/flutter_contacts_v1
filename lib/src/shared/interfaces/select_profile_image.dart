import 'package:flutter/material.dart';

import '../contact_model.dart';
import '../enum_profile_image_type.dart';

abstract class ISelectProfileImage {
  ValueNotifier<ProfileImageType?> profileImageType = ValueNotifier(null);

  void selectUrlImage() {}
  void setUrlImage(ContactModel contact, String imageUrl) {}

  void setGalleryImage(ContactModel contact) async {}

  void setCameraImage(ContactModel contact) async {}
}
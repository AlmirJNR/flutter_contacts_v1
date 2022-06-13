import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/src/shared/contact_model.dart';

import '../enum_profile_image_type.dart';
import '../interfaces/select_profile_image.dart';

class SelectProfileImageTypeWidget extends StatefulWidget {
  final ISelectProfileImage parentController;
  final ContactModel contact;
  final TextEditingController textProfilePictureController;

  const SelectProfileImageTypeWidget({
    Key? key,
    required this.parentController,
    required this.contact,
    required this.textProfilePictureController,
  }) : super(key: key);

  @override
  State<SelectProfileImageTypeWidget> createState() => _SelectProfileImageTypeWidgetState();
}

class _SelectProfileImageTypeWidgetState extends State<SelectProfileImageTypeWidget> {
  @override
  void dispose() {
    widget.parentController.profileImageType = ValueNotifier(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProfileImageType?>(
      valueListenable: widget.parentController.profileImageType,
      builder: (context, profileImageType, child) {
        switch (profileImageType) {
          case null:
          case ProfileImageType.gallery:
          case ProfileImageType.camera:
            return AlertDialog(
              title: const Text(
                'New Profile Image Type',
                textAlign: TextAlign.center,
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => widget.parentController.selectUrlImage(),
                    icon: const Icon(Icons.link),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.parentController.setGalleryImage(widget.contact);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.parentController.setCameraImage(widget.contact);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.camera_alt),
                  ),
                ],
              ),
            );
          case ProfileImageType.url:
            return AlertDialog(
              title: const Text(
                'Profile Image Url',
                textAlign: TextAlign.center,
              ),
              content: TextFormField(
                keyboardType: TextInputType.url,
                controller: widget.textProfilePictureController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    widget.parentController.setUrlImage(
                      widget.contact,
                      widget.textProfilePictureController.text,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
        }
      },
    );
  }
}

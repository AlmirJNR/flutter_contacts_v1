import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/src/modules/contact/edit/edit_contact_page.dart';
import 'package:flutter_contacts_v1/src/shared/contact_model.dart';

import '../../../shared/constants.dart';
import '../../../shared/widgets/contact_profile_image.dart';

class ContactListItemWidget extends StatelessWidget {
  final ContactModel contact;
  final double avatarSize;
  final double fallbackAvatarSize;

  const ContactListItemWidget({
    Key? key,
    required this.contact,
    required this.avatarSize,
    required this.fallbackAvatarSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      openElevation: 0,
      openBuilder: (context, action) => EditContactPage(contact: contact),
      closedElevation: 0,
      closedBuilder: (context, action) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: kContentHorizontalPadding),
          title: Text(contact.name),
          subtitle: Text(contact.email),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: ContactProfileImageWidget(
              imagePath: contact.profilePicture,
              profileImageType: contact.profileImageType,
              avatarSize: avatarSize,
              fallbackAvatarSize: fallbackAvatarSize,
            ),
          ),
        );
      },
    );
  }
}

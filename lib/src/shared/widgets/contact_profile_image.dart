import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/src/shared/enum_profile_image_type.dart';
import 'package:transparent_image/transparent_image.dart';

class ContactProfileImageWidget extends StatelessWidget {
  final String imagePath;
  final ProfileImageType? profileImageType;
  final double avatarSize;
  final double fallbackAvatarSize;

  const ContactProfileImageWidget({
    Key? key,
    required this.imagePath,
    required this.profileImageType,
    required this.avatarSize,
    required this.fallbackAvatarSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (profileImageType) {
      case ProfileImageType.url:
        return FadeInImage.memoryNetwork(
          height: avatarSize,
          width: avatarSize,
          placeholder: kTransparentImage,
          placeholderFit: BoxFit.cover,
          image: imagePath,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, object, stackTrace) {
            return Container(
              color: Colors.blue,
              height: avatarSize,
              width: avatarSize,
              child: Icon(
                Icons.person,
                size: fallbackAvatarSize,
                color: Colors.white,
              ),
            );
          },
        );
      case ProfileImageType.camera:
      case ProfileImageType.gallery:
        return Image.file(
          File(imagePath),
          height: avatarSize,
          width: avatarSize,
          fit: BoxFit.cover,
        );
      default:
        return Container(
          color: Colors.blue,
          height: avatarSize,
          width: avatarSize,
          child: Icon(
            Icons.person,
            size: fallbackAvatarSize,
            color: Colors.white,
          ),
        );
    }
  }
}

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../contact/add/add_contact_page.dart';

class FloatingAddContactButtonWidget extends StatelessWidget {
  final double buttonSize;

  const FloatingAddContactButtonWidget({
    Key? key,
    required this.buttonSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (context, action) => const AddContactPage(),
      closedShape: const CircleBorder(),
      closedColor: Theme.of(context).primaryColor,
      closedBuilder: (context, action) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          height: buttonSize,
          width: buttonSize,
          child: const Icon(
            Icons.person_add_rounded,
            color: Colors.white,
            size: 32,
          ),
        );
      },
    );
  }
}

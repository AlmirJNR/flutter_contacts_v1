import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_controller.dart';
import 'contact_list_item.dart';

class ContactListWidget extends StatelessWidget {

  const ContactListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, homeController, child) {
        return ListView.builder(
          itemCount: homeController.contacts.length + 1,
          itemBuilder: (context, index) {
            if (index != homeController.contacts.length) {
              return SizedBox(
                height: 75,
                child: ContactListItemWidget(
                  contact: homeController.contacts[index],
                  avatarSize: 48,
                  fallbackAvatarSize: 32,
                ),
              );
            }

            return const SizedBox(height: 75);
          },
        );
      },
    );
  }
}

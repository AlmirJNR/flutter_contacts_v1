import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/src/modules/contact/edit/edit_contact_controller.dart';
import 'package:flutter_contacts_v1/src/modules/contact/edit/widgets/contact_bottom_buttons.dart';
import 'package:flutter_contacts_v1/src/shared/database_client.dart';
import 'package:flutter_contacts_v1/src/shared/widgets/select_profile_image_type.dart';
import 'package:flutter_contacts_v1/src/shared/widgets/contact_profile_image.dart';
import 'package:flutter_contacts_v1/src/shared/contact_model.dart';
import 'package:flutter_contacts_v1/src/shared/widgets/text_form_fields/email.dart';
import 'package:flutter_contacts_v1/src/shared/widgets/text_form_fields/name.dart';
import 'package:flutter_contacts_v1/src/shared/widgets/text_form_fields/notes.dart';
import 'package:flutter_contacts_v1/src/shared/widgets/text_form_fields/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/constants.dart';

class EditContactPage extends StatefulWidget {
  final ContactModel contact;
  final double avatarSize;
  final double fallbackAvatarSize;
  final double saveContactIconSize;

  const EditContactPage({
    Key? key,
    required this.contact,
    this.avatarSize = kLargeAvatarSize,
    this.fallbackAvatarSize = kFallbackLargeAvatarSize,
    this.saveContactIconSize = kFloatingActionContainerButtonIconSize,
  }) : super(key: key);

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late final EditContactController editContactController;
  late final GlobalKey<FormState> formKey;
  late final TextEditingController textProfilePictureController;
  late final TextEditingController textNameController;
  late final TextEditingController textEmailController;
  late final List<TextEditingController> textPhoneNumberControllers;
  late final TextEditingController textNotesController;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    formKey = GlobalKey<FormState>(debugLabel: 'EDIT Contact Form Key');

    textProfilePictureController = TextEditingController();
    textNameController = TextEditingController();
    textEmailController = TextEditingController();
    textPhoneNumberControllers = <TextEditingController>[];
    textNotesController = TextEditingController();

    editContactController = EditContactController(databaseClient: context.read<DatabaseClient>());

    textProfilePictureController.text = widget.contact.profilePicture;
    textNameController.text = widget.contact.name;
    textEmailController.text = widget.contact.email;

    for (int i = 0; i < widget.contact.phoneNumbers.length; i++) {
      textPhoneNumberControllers.add(TextEditingController());
      textPhoneNumberControllers[i].text = widget.contact.phoneNumbers[i];
    }

    textNotesController.text = widget.contact.notes;
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    textProfilePictureController.dispose();
    textNameController.dispose();
    textEmailController.dispose();
    for (TextEditingController controllers in textPhoneNumberControllers) {
      controllers.dispose();
    }
    textNotesController.dispose();
    editContactController.dispose();
    super.dispose();
  }

  void _callContact() {
    if (widget.contact.phoneNumbers.isEmpty) return;

    final Uri telLaunchUri = Uri(
      scheme: 'tel',
      path: widget.contact.phoneNumbers[0],
    );

    launchUrl(telLaunchUri);
  }

  void _messageContact() {
    if (widget.contact.phoneNumbers.isEmpty) return;

    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: widget.contact.phoneNumbers[0],
    );

    launchUrl(smsLaunchUri);
  }

  void _emailContact() {
    if (widget.contact.email.isEmpty) return;

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: widget.contact.email,
      queryParameters: {'subject': 'Insert your subject'},
    );

    launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(kContentHorizontalPadding, 16.0, kContentHorizontalPadding, 32.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(64.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        DialogRoute(
                          context: context,
                          builder: (context) => SelectProfileImageTypeWidget(
                            parentController: editContactController,
                            contact: widget.contact,
                            textProfilePictureController: textProfilePictureController,
                          ),
                        ),
                      ),
                      child: ListenableProvider(
                        create: (context) => editContactController,
                        builder: (context, child) {
                          return Consumer<EditContactController>(
                            builder: (context, value, child) {
                              return ContactProfileImageWidget(
                                imagePath: widget.contact.profilePicture,
                                profileImageType: widget.contact.profileImageType,
                                avatarSize: widget.avatarSize,
                                fallbackAvatarSize: widget.fallbackAvatarSize,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  NameTextFormFieldWidget(textEditingController: textNameController),
                  const SizedBox(height: 16),
                  EmailTextFormFieldWidget(textEditingController: textEmailController),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.contact.phoneNumbers.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PhoneNumberTextFormField(
                            textEditingController: textPhoneNumberControllers[index],
                            index: index,
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                  NotesTextFormFieldWidget(textEditingController: textNotesController),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        height: widget.saveContactIconSize,
        width: widget.saveContactIconSize,
        child: IconButton(
          onPressed: () => editContactController.updateContact(
            formKey,
            contact: widget.contact,
            textNameController: textNameController,
            textEmailController: textEmailController,
            textPhoneNumberControllers: textPhoneNumberControllers,
            textNotesController: textNotesController,
          ),
          icon: const Icon(Icons.save),
          color: Colors.white,
          iconSize: kFloatingActionButtonIconSize,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: OrientationBuilder(
          builder: (context, orientation) {
            final Row row = Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ContactBottomButtonsWidget(
                  icon: const Icon(
                    Icons.call,
                    color: Colors.white,
                    size: kBottomNavigationBarIconsSize,
                  ),
                  text: 'Call',
                  onTap: _callContact,
                ),
                ContactBottomButtonsWidget(
                  icon: const Icon(
                    Icons.message,
                    color: Colors.white,
                    size: kBottomNavigationBarIconsSize,
                  ),
                  text: 'Message',
                  onTap: _messageContact,
                ),
                ContactBottomButtonsWidget(
                  icon: const Icon(
                    Icons.email,
                    color: Colors.white,
                    size: kBottomNavigationBarIconsSize,
                  ),
                  text: 'Email',
                  onTap: _emailContact,
                ),
              ],
            );

            switch (orientation) {
              case Orientation.portrait:
                row.children.add(const SizedBox(width: 32.0));
                return row;
              case Orientation.landscape:
                return row;
            }
          },
        ),
      ),
    );
  }
}

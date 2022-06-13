import 'package:flutter/material.dart';
import 'package:flutter_contacts_v1/src/modules/contact/add/add_contact_controller.dart';
import 'package:flutter_contacts_v1/src/modules/home/home_controller.dart';
import 'package:flutter_contacts_v1/src/shared/contact_model.dart';
import 'package:provider/provider.dart';

import '../../../shared/constants.dart';
import '../../../shared/database_client.dart';
import '../../../shared/widgets/contact_profile_image.dart';
import '../../../shared/widgets/select_profile_image_type.dart';
import '../../../shared/widgets/text_form_fields/email.dart';
import '../../../shared/widgets/text_form_fields/name.dart';
import '../../../shared/widgets/text_form_fields/notes.dart';
import '../../../shared/widgets/text_form_fields/phone_number.dart';

class AddContactPage extends StatefulWidget {
  final double avatarSize;
  final double fallbackAvatarSize;
  final double saveContactIconSize;

  const AddContactPage({
    Key? key,
    this.avatarSize = kLargeAvatarSize,
    this.fallbackAvatarSize = kFallbackLargeAvatarSize,
    this.saveContactIconSize = kFloatingActionContainerButtonIconSize,
  }) : super(key: key);

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  late final ContactModel newContact;
  late final AddContactController addContactController;
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

    formKey = GlobalKey<FormState>(debugLabel: 'ADD Contact Form Key');

    textProfilePictureController = TextEditingController();
    textNameController = TextEditingController();
    textEmailController = TextEditingController();
    textPhoneNumberControllers = <TextEditingController>[
      TextEditingController(),
    ];
    textNotesController = TextEditingController();

    addContactController = AddContactController(
      databaseClient: context.read<DatabaseClient>(),
      homeController: context.read<HomeController>(),
    );
    newContact = ContactModel();
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
    addContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add contact'),
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
                            parentController: addContactController,
                            contact: newContact,
                            textProfilePictureController: textProfilePictureController,
                          ),
                        ),
                      ),
                      child: ListenableProvider(
                        create: (context) => addContactController,
                        builder: (context, child) {
                          return Consumer<AddContactController>(
                            builder: (context, value, child) {
                              return ContactProfileImageWidget(
                                imagePath: newContact.profilePicture,
                                profileImageType: newContact.profileImageType,
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
                  PhoneNumberTextFormField(
                    textEditingController: textPhoneNumberControllers[0],
                    index: 0,
                  ),
                  const SizedBox(height: 16),
                  NotesTextFormFieldWidget(textEditingController: textNotesController),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        height: widget.saveContactIconSize,
        width: widget.saveContactIconSize,
        child: IconButton(
          onPressed: () {
            addContactController.createContact(
              formKey,
              contact: newContact,
              textNameController: textNameController,
              textEmailController: textEmailController,
              textPhoneNumberControllers: textPhoneNumberControllers,
              textNotesController: textNotesController,
            );
          },
          icon: const Icon(Icons.save),
          color: Colors.white,
          iconSize: kFloatingActionButtonIconSize,
        ),
      ),
    );
  }
}

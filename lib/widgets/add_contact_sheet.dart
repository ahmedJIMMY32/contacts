import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../models/contact_model.dart';
import 'cream_button.dart';
import 'custom_text_field.dart';

class AddContactSheet extends StatefulWidget {
  const AddContactSheet({super.key});

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? imagePath;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        imagePath = file.path;
      });
    }
  }

  void addContact() {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      return;
    }

    Navigator.pop(
      context,
      ContactModel(
        name: name,
        email: email,
        phone: phone,
        imagePath: imagePath,
      ),
    );
  }

  void refresh(String value) {
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String nameText =
    nameController.text.isEmpty ? 'User Name' : nameController.text;
    final String emailText =
    emailController.text.isEmpty ? 'example@email.com' : emailController.text;
    final String phoneText =
    phoneController.text.isEmpty ? '+200000000000' : phoneController.text;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: 140,
                    height: 140,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.cream, width: 1.5),
                    ),
                    child: imagePath == null
                        ? const Icon(
                      Icons.photo_library_outlined,
                      size: 60,
                      color: AppColors.cream,
                    )
                        : Image.file(File(imagePath!), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameText,
                          style: AppTextStyles.previewText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Divider(color: AppColors.cream, height: 1),
                        Text(
                          emailText,
                          style: AppTextStyles.previewText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Divider(color: AppColors.cream, height: 1),
                        Text(
                          phoneText,
                          style: AppTextStyles.previewText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: nameController,
              hint: 'Enter User Name',
              onChanged: refresh,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: emailController,
              hint: 'Enter User Email',
              keyboardType: TextInputType.emailAddress,
              onChanged: refresh,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: phoneController,
              hint: 'Enter User Phone',
              keyboardType: TextInputType.phone,
              onChanged: refresh,
            ),
            const SizedBox(height: 16),
            CreamButton(title: 'Enter user', onPressed: addContact),
          ],
        ),
      ),
    );
  }
}
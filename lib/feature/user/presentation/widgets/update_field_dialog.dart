import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_chat_app/feature/app/theme/style.dart';
import 'package:just_chat_app/feature/user/presentation/widgets/profile_text_field.dart';

class UpdateFieldDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;
  bool isPasswordChange;
  String? username;
  final Function(String?)? onUpdate;

  UpdateFieldDialog({super.key, required this.isPasswordChange, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        isPasswordChange ? 'Change Password' : 'Change Username',
        style: GoogleFonts.comfortaa(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(isPasswordChange)
              ProfileTextField(
                hintText: 'Current Password',
                isPassword: true,
                onChanged: (value) => currentPassword = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              ProfileTextField(
                hintText: isPasswordChange ? 'New Password' : 'New Username',
                isPassword: isPasswordChange,
                onChanged: (value) => isPasswordChange ? newPassword = value : username = value,
                validator: isPasswordChange ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a new password';
                  }
                  const passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
                  final regex = RegExp(passwordPattern);
                  if (!regex.hasMatch(value.trim())) {
                    return 'Password must be 8+ characters with letters and numbers';
                  }
                  return null;
                } : null,
              ),
              const SizedBox(height: 15),
              if(isPasswordChange)
              ProfileTextField(
                hintText: 'Confirm New Password',
                isPassword: true,
                onChanged: (value) => confirmPassword = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value.trim() != newPassword?.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.comfortaa(
              color: AppColors.secondaryTextColor,
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (onUpdate != null) {
                if (isPasswordChange) {
                  onUpdate!(newPassword); // Pass new password
                } else {
                  onUpdate!(username); // Pass new username
                }
              }
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.sendMessageColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'Change',
            style: GoogleFonts.comfortaa(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
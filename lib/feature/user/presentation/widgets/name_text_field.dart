import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/style.dart';

class NameTextField extends StatefulWidget {
  final bool isFirstName;
  final ValueChanged<String>? onChanged;
  const NameTextField({super.key, required this.isFirstName, this.onChanged});

  @override
  State<NameTextField> createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  final TextEditingController _controller = TextEditingController();

  String? _validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter first name';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    const firstNamePattern = r'^[a-zA-Z]+$';
    final regex = RegExp(firstNamePattern);
    if (!regex.hasMatch(value.trim())) {
      return 'First name must contain only letters';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter last name';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    const lastNamePattern = r'^[a-zA-Z]+$';
    final regex = RegExp(lastNamePattern);
    if (!regex.hasMatch(value.trim())) {
      return 'Last name must contain only letters';
    }
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: TextFormField(
        controller: _controller,
        onChanged: widget.onChanged,
        keyboardType: TextInputType.text,
        style: GoogleFonts.comfortaa(
          color: AppColors.textColor,
          fontSize: 20,
        ),
        cursorColor: Colors.white,
        cursorOpacityAnimates: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          hintText: widget.isFirstName ? "First name" : "Last name",
          hintStyle: GoogleFonts.comfortaa(
            color: AppColors.secondaryTextColor,
            fontSize: 20,
          ),
          filled: true,
          fillColor: AppColors.appBarColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 3, color: AppColors.sendMessageColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 3, color: AppColors.sendMessageColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 3, color: AppColors.sendMessageColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 3, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 3, color: Colors.red),
          ),
          errorStyle: GoogleFonts.comfortaa(
            color: Colors.red,
            fontSize: 12,
          ),
          errorMaxLines: 2,
        ),
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        validator: widget.isFirstName ? _validateFirstName : _validateLastName,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
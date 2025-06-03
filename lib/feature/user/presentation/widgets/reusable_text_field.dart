import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/style.dart';

class ReusableTextField extends StatefulWidget {
  final bool isEmail;
  final ValueChanged<String>? onChanged;
  const ReusableTextField({super.key, required this.isEmail, this.onChanged});

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  final TextEditingController _controller = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email';
    }
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a password';
    }
    // const passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
    // final regex = RegExp(passwordPattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return 'Password must be 8+ characters with letters and numbers';
    // }
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: TextFormField(
        controller: _controller,
        onChanged: widget.onChanged,
        keyboardType: widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: GoogleFonts.comfortaa(
          color: AppColors.textColor,
          fontSize: 20,
        ),
        cursorColor: Colors.white,
        cursorOpacityAnimates: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          hintText: widget.isEmail ? "Email" : "Password",
          hintStyle: GoogleFonts.comfortaa(
            color: AppColors.secondaryTextColor,
            fontSize: 20,
          ),
          filled: true,
          fillColor: AppColors.appBarColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 3, color: AppColors.sendMessageColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 3, color: AppColors.sendMessageColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 3, color: AppColors.sendMessageColor),
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
        obscureText: !widget.isEmail,
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        validator: widget.isEmail ? _validateEmail : _validatePassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/style.dart';

class ChatSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const ChatSearchBar({super.key, this.onChanged, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 60, // Responsive height
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        cursorColor: Colors.white,
        onChanged: onChanged,
        style: GoogleFonts.comfortaa(color: AppColors.textColor, fontSize: 22),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 15, left: 25, right: 0, bottom: 5),
          border: InputBorder.none,
          hintText: "Search chat...",
          hintStyle: GoogleFonts.comfortaa(
            color: AppColors.secondaryTextColor,
            fontSize: 22,
          ),
          suffixIcon: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) {
                return IconButton(
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  icon: const Icon(
                    Icons.search,
                    size: 40,
                    color: AppColors.secondaryTextColor,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                  },
                );
              } else {
                return IconButton(
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  icon: const Icon(Icons.clear, size: 40, color: AppColors.secondaryTextColor),
                  onPressed: () {
                    controller.clear();
                    onChanged?.call('');
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

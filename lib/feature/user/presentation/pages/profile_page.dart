import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_chat_app/feature/user/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:just_chat_app/feature/user/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:just_chat_app/feature/user/presentation/widgets/update_field_dialog.dart';
import '../../../../main.dart';
import '../../../app/theme/style.dart';
import '../../../app/routes/on_generate_route.dart';
import '../widgets/profile_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isUpdating = false;
  // final _pic = ImagePicker();
  // String? _profilePicPath;

  @override
  void initState() {
    super.initState();
    // _loadProfilePic();
    context.read<UserCubit>().fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBarColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.backgroundColor,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  "Profile Settings",
                  style: GoogleFonts.comfortaa(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                child: BlocConsumer<UserCubit, UserState>(
                  listener: (context, state){
                    if (state is UserError) {
                      setState(() => isUpdating = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }else if (state is UserLoaded && state.isUpdated) {
                      setState(() => isUpdating = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated successfully!')),
                      );
                    }
                  },
                  builder: (context, state) {
                    String username = 'User';
                    String email = 'Not available';
                    String? profilePicUrl;

                    if (state is UserLoaded) {
                      username = state.name;
                      email = state.email;
                      profilePicUrl = state.image;
                    } else if(state is UserLoading && !isUpdating){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if(state is UserError && !isUpdating){
                      return Center(
                        child: Text(
                          'Failed to load profile: ${state.message}',
                          style: GoogleFonts.comfortaa(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          // onTap: profilePic,
                          onTap: () {
                            // Placeholder for profile picture update functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile picture update coming soon')),
                            );
                          },
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            child:
                            // _profilePicPath != null
                            //     ? ClipRRect(
                            //   borderRadius: BorderRadius.circular(70),
                            //   child: Image.file(
                            //     File(_profilePicPath!),
                            //     width: 130,
                            //     height: 130,
                            //     fit: BoxFit.cover,
                            //     errorBuilder: (context, error, stackTrace) {
                            //       return _buildDefaultAvatar(username);
                            //     },
                            //   ),
                            // )
                            profilePicUrl != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.network(
                                profilePicUrl,
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultAvatar(username);
                                },
                              ),
                            )
                                : _buildDefaultAvatar(username),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          // "Edit profile picture",
                          username,
                          style: GoogleFonts.comfortaa(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 40),
                        ProfileTextField(
                          suffixIcon: IconButton(
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (context) => UpdateFieldDialog(
                                    isPasswordChange: false,
                                    onUpdate: (newUsername) {
                                      if (newUsername != null) {
                                        final authState = context.read<AuthCubit>().state;
                                        if (authState is Authenticated) {
                                          context.read<UserCubit>().updateUserProfile(newUsername, null);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Authentication token not found')),
                                          );
                                        }
                                        print('Updated username: $newUsername');
                                      }
                                    },
                                  ),
                                );
                              },
                              icon: const Icon(
                                  Icons.edit,
                                color: AppColors.textColor,
                              ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          hintText: "Username",
                          initialValue: username,
                          isEditable: false,
                          onChanged: (value) {
                            print('Username input: $value');
                          },
                        ),
                        const SizedBox(height: 30),
                        ProfileTextField(
                          hintText: "Email",
                          initialValue: email,
                          isEditable: false,
                        ),
                        const SizedBox(height: 30),
                        ProfileTextField(
                          hintText: "Change Password",
                          isEditable: false,
                          isPassword: true,
                          suffixIcon: IconButton(
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context) => UpdateFieldDialog(
                                  isPasswordChange: true,
                                  onUpdate: (newPassword) {
                                    if (newPassword != null) {
                                      print('Updated password: $newPassword');
                                    }
                                  },
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.textColor,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is Unauthenticated) {
                                navigatorKey.currentState!.pushNamedAndRemoveUntil(
                                    PageConst.login,
                                        (Route<dynamic> route) => false,
                                );
                              } else if (state is AuthError) {
                                // Display error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            builder:(context, state){
                              final isLoading = state is AuthLoading;
                              return ElevatedButton(
                              onPressed: () {
                                // Added: Trigger logout via AuthCubit
                                context.read<AuthCubit>().signOut();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.sendMessageColor,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: isLoading ? const CircularProgressIndicator() : Text(
                                "Logout",
                                style: GoogleFonts.comfortaa(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(String username) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appBarColor, width: 6),
        borderRadius: BorderRadius.circular(70),
      ),
      child: Center(
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : '+',
          style: GoogleFonts.comfortaa(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: AppColors.appBarColor,
          ),
        ),
      ),
    );
  }

  // void _showPasswordChangeDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       String? currentPassword;
  //       String? newPassword;
  //       String? confirmPassword;
  //       final formKey = GlobalKey<FormState>();
  //
  //       return AlertDialog(
  //         backgroundColor: AppColors.backgroundColor,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         title: Text(
  //           'Change Password',
  //           style: GoogleFonts.comfortaa(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.textColor,
  //           ),
  //         ),
  //         content: Form(
  //           key: formKey,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 ProfileTextField(
  //                   hintText: 'Current Password',
  //                   isPassword: true,
  //                   onChanged: (value) => currentPassword = value,
  //                   validator: (value) {
  //                     if (value == null || value.trim().isEmpty) {
  //                       return 'Please enter current password';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 const SizedBox(height: 15),
  //                 ProfileTextField(
  //                   hintText: 'New Password',
  //                   isPassword: true,
  //                   onChanged: (value) => newPassword = value,
  //                   validator: (value) {
  //                     if (value == null || value.trim().isEmpty) {
  //                       return 'Please enter a new password';
  //                     }
  //                     const passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
  //                     final regex = RegExp(passwordPattern);
  //                     if (!regex.hasMatch(value.trim())) {
  //                       return 'Password must be 8+ characters with letters and numbers';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 const SizedBox(height: 15),
  //                 ProfileTextField(
  //                   hintText: 'Confirm New Password',
  //                   isPassword: true,
  //                   onChanged: (value) => confirmPassword = value,
  //                   validator: (value) {
  //                     if (value == null || value.trim().isEmpty) {
  //                       return 'Please confirm your password';
  //                     }
  //                     if (value.trim() != newPassword?.trim()) {
  //                       return 'Passwords do not match';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text(
  //               'Cancel',
  //               style: GoogleFonts.comfortaa(
  //                 color: AppColors.secondaryTextColor,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (formKey.currentState!.validate()) {
  //                 Navigator.pop(context);
  //               }
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: AppColors.sendMessageColor,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //             ),
  //             child: Text(
  //               'Change',
  //               style: GoogleFonts.comfortaa(fontSize: 16, color: Colors.white),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _loadProfilePic() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/profile_pic.jpg');
  //   if (await file.exists()) {
  //     setState(() {
  //       _profilePicPath = file.path;
  //     });
  //   } else {
  //     debugPrint('No profile picture found');
  //   }
  // }
  //
  // Future<void> profilePic() async {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: AppColors.backgroundColor,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         ListTile(
  //           leading: Icon(Icons.photo_library, color: AppColors.textColor),
  //           title: Text(
  //             'Choose from Gallery',
  //             style: GoogleFonts.comfortaa(
  //               color: AppColors.textColor,
  //               fontSize: 16,
  //             ),
  //           ),
  //           onTap: () {
  //             Navigator.pop(context);
  //             _pickImage(ImageSource.gallery);
  //           },
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.camera_alt, color: AppColors.textColor),
  //           title: Text(
  //             'Take a Photo',
  //             style: GoogleFonts.comfortaa(
  //               color: AppColors.textColor,
  //               fontSize: 16,
  //             ),
  //           ),
  //           onTap: () {
  //             Navigator.pop(context);
  //             _pickImage(ImageSource.camera);
  //           },
  //         ),
  //         SizedBox(height: 20),
  //       ],
  //     ),
  //   );
  // }
  //
  // Future<void> _pickImage(ImageSource source) async {
  //   debugPrint('Picking image from $source...');
  //   try {
  //     final imagePicked = await _pic.pickImage(source: source);
  //     if (imagePicked == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('No image selected or taken')),
  //       );
  //       return;
  //     }
  //
  //     final directory = await getApplicationDocumentsDirectory();
  //     final file = File('${directory.path}/profile_pic.jpg');
  //     final newImage = await File(imagePicked.path).copy(file.path);
  //
  //     setState(() {
  //       _profilePicPath = newImage.path;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to pick image: $e')),
  //     );
  //   }
  // }
}
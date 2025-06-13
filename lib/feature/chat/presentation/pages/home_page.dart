import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_chat_app/feature/chat/domain/entity/chat_entity.dart';
import 'package:just_chat_app/feature/chat/presentation/chat_cubit/chat_cubit.dart';
import '../../../app/routes/on_generate_route.dart';
import '../../../app/theme/style.dart';
import '../../../user/presentation/cubit/user_cubit/user_cubit.dart';
import '../widgets/chat_list_generate.dart';
import '../widgets/chat_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  List<ChatEntity> get filteredChats {
    final state = context.read<ChatCubit>().state;
    final chats = state.chats;
    if (_searchController.text.isEmpty) {
      return chats;
    } else {
      return chats.where((chat) {
        return chat.partnerName.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUser();
    context.read<ChatCubit>().fetchAllChats();
  }

  @override
  void dispose() {
    _searchController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.appBarColor,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Connect ",
                            style: GoogleFonts.comfortaa(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            "With",
                            style: GoogleFonts.comfortaa(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Your Friends!",
                        style: GoogleFonts.comfortaa(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.textColor,
                                width: 4),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.backgroundColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      title: Text(
                                        'Start a new chat',
                                        style: GoogleFonts.comfortaa(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                      content: Form(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: emailController,
                                              keyboardType: TextInputType.text,
                                              style: GoogleFonts.comfortaa(color: AppColors.textColor, fontSize: 20),
                                              cursorColor: Colors.white,
                                              cursorOpacityAnimates: true,
                                              enableInteractiveSelection: true,
                                              decoration: InputDecoration(
                                                labelText: "Email",
                                                labelStyle: GoogleFonts.comfortaa(color: AppColors.textColor, fontSize: 20),
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                                filled: true,
                                                fillColor: AppColors.appBarColor,
                                                border: OutlineInputBorder(
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
                                                errorStyle: GoogleFonts.comfortaa(color: Colors.red, fontSize: 12),
                                                errorMaxLines: 2,
                                              ),
                                              onTapOutside: (_) {
                                                FocusScope.of(context).unfocus();
                                              },
                                            ),
                                            const SizedBox(height: 20,),
                                            TextFormField(
                                              controller: messageController,
                                              keyboardType: TextInputType.text,
                                              style: GoogleFonts.comfortaa(color: AppColors.textColor, fontSize: 20),
                                              cursorColor: Colors.white,
                                              cursorOpacityAnimates: true,
                                              enableInteractiveSelection: true,
                                              decoration: InputDecoration(
                                                labelText: "Message",
                                                labelStyle: GoogleFonts.comfortaa(color: AppColors.textColor, fontSize: 20),
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                                filled: true,
                                                fillColor: AppColors.appBarColor,
                                                border: OutlineInputBorder(
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
                                                errorStyle: GoogleFonts.comfortaa(color: Colors.red, fontSize: 12),
                                                errorMaxLines: 2,
                                              ),
                                              onTapOutside: (_) {
                                                FocusScope.of(context).unfocus();
                                              },
                                            ),
                                          ],
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
                                            context.read<ChatCubit>().sendMessage({
                                              "receiverEmail": emailController.text.trim(),
                                              "content": messageController.text.trim(),
                                            });
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.sendMessageColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            'Send',
                                            style: GoogleFonts.comfortaa(fontSize: 16, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                color: AppColors.textColor,
                              )
                          )
                      ),
                      const SizedBox(width: 20,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageConst.profile);
                        },
                        child: BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            String? profilePicUrl;
                            String username = 'User';
                            if (state is UserLoading) {
                              return const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: CircularProgressIndicator(color: AppColors.textColor),
                              );
                            } else if (state is UserLoaded) {
                              profilePicUrl = state.image;
                              username = state.name;
                            }
                            return CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: profilePicUrl != null && profilePicUrl.isNotEmpty
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(
                                  profilePicUrl,
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint('HomePage image load error: $error');
                                    return _buildDefaultAvatar(username);
                                  },
                                ),
                              )
                                  : _buildDefaultAvatar(username),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ChatSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 15),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: BlocConsumer<ChatCubit, ChatState>(
                  listener: (context, state) {
                    if(state is ChatError){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                    },
                  builder: (context, state) {
                    if(state is ChatLoading){
                      return const Center(child: CircularProgressIndicator(),);
                    } else if(state is ChatLoaded){
                      return _buildChatContent();
                    }
                    return _buildChatContent();
                    },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(String username) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appBarColor, width: 4),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : 'U',
          style: GoogleFonts.comfortaa(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.appBarColor,
          ),
        ),
      ),
    );
  }

  Widget _buildChatContent() {
    return filteredChats.isNotEmpty
        ? ChatListGenerate(chats: filteredChats)
        : Center(
      child: Text(
        "Start a chat",
        style: GoogleFonts.comfortaa(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.secondaryTextColor,
        ),
      ),
    );
  }
}


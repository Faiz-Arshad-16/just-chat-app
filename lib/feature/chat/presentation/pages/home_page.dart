import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/const/chat_list_model.dart';
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

  List<Chat> get filteredChats {
    if (_searchController.text.isEmpty) {
      return allChats;
    } else {
      return allChats.where((chat) {
        return chat.name.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUser();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                color: AppColors.textColor,
                              )
                          )
                      ),
                      SizedBox(width: 20,),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pushNamed(context, PageConst.profile).then((_) {});
                        },
                        child: BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            String? profilePicUrl;
                            String username = 'User';
                            if (state is UserLoading) {
                              return CircleAvatar(
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
            SizedBox(height: 10),
            ChatSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: _buildChatContent(),
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

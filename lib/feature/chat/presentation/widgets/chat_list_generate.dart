import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:just_chat_app/feature/chat/domain/entity/chat_entity.dart';
import 'package:just_chat_app/feature/chat/presentation/chat_cubit/chat_cubit.dart';
import '../../../app/routes/on_generate_route.dart';
import '../../../app/theme/style.dart';

class ChatListGenerate extends StatelessWidget {
  final List<ChatEntity> chats;

  const ChatListGenerate({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _buildChatList(context, chat);
      },
    );
  }

  Widget _buildChatList(BuildContext context, ChatEntity chat) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PageConst.chats, arguments: chat);
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) =>
                    BlocConsumer<ChatCubit, ChatState>(
                      listener: (context, state) {
                        if (state is ChatError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        } else if (state is ChatLoaded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Chat deleted successfully')),
                          );
                          context.read<ChatCubit>().fetchAllChats();

                          Navigator.pop(context); // Close dialog on success
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is ChatLoading;
                        return AlertDialog(
                          backgroundColor: AppColors.backgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Text(
                            'Delete Chat',
                            style: GoogleFonts.comfortaa(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                          content: Text(
                            "Are you sure you want to delete the chat?",
                            style: GoogleFonts.comfortaa(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
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
                              onPressed: isLoading
                                  ? null
                                  : () {
                                context.read<ChatCubit>().deleteChat(
                                    chat.chatGroupId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.sendMessageColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : Text(
                                'Delete',
                                style: GoogleFonts.comfortaa(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    )
            );
          },
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.appBarColor,
                    child: chat.partnerProfilePic == null ? Text(
                      chat.partnerName.isNotEmpty ? chat.partnerName[0]
                          .toUpperCase() : '?',
                      style: GoogleFonts.comfortaa(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        chat.partnerProfilePic!,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.partnerName,
                          style: GoogleFonts.comfortaa(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          chat.lastMessage?.content ?? "No messages yet",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.comfortaa(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (chat.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.sendMessageColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: GoogleFonts.comfortaa(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Text(
                        _formatLastMessageTime(chat.lastMessage?.createdAt),
                        style: GoogleFonts.comfortaa(
                          fontSize: 11,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(color: AppColors.secondaryTextColor.withOpacity(0.5)),
      ],
    );
  }

  String _formatLastMessageTime(DateTime? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE').format(timestamp);
    } else {
      return DateFormat('MM/dd').format(timestamp);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:just_chat_app/feature/chat/domain/entity/chat_entity.dart';
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
                      chat.partnerName.isNotEmpty ? chat.partnerName[0].toUpperCase() : '?',
                      style: GoogleFonts.comfortaa(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                    : Image.network(
                    chat.partnerProfilePic!,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,),
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
                  Text(
                    _formatLastMessageTime(chat.lastMessage?.createdAt),
                    style: GoogleFonts.comfortaa(
                      fontSize: 11,
                      color: AppColors.secondaryTextColor,
                    ),
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

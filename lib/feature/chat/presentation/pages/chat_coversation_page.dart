
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_chat_app/feature/chat/domain/entity/chat_entity.dart';
import 'package:just_chat_app/feature/chat/domain/entity/message_entity.dart';
import 'package:just_chat_app/feature/chat/presentation/chat_cubit/chat_cubit.dart';
import '../../../app/theme/style.dart';

class ChatConversationPage extends StatefulWidget {
  final ChatEntity chat;

  const ChatConversationPage({super.key, required this.chat});

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<MessageEntity> _chatMessages;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().fetchChat(widget.chat.chatGroupId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.appBarColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.backgroundColor,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppColors.appBarColor,
                      ),
                      child: widget.chat.partnerProfilePic != null ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child:Image.network(
                          widget.chat.partnerProfilePic!,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        )
                      ) : Center(
                        child: Text(
                          widget.chat.partnerName.isNotEmpty ? widget.chat.partnerName[0].toUpperCase() : '?',
                          style: GoogleFonts.comfortaa(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    widget.chat.partnerName,
                    style: GoogleFonts.comfortaa(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state){
                      if(state is ChatLoading){
                        return const Center(child: CircularProgressIndicator(),);
                      }
                      if(state is ChatError){
                        return Center(
                          child: Text(
                            'No messages yet',
                            style: GoogleFonts.comfortaa(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                        );
                      }
                      final messages = state.messages.reversed.toList();
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isUser = message.isSentByUser;
                          return Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isUser ? AppColors.sendMessageColor : AppColors.receiveMessageColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(15),
                                  topRight: const Radius.circular(15),
                                  bottomLeft: isUser ? const Radius.circular(15) : Radius.zero,
                                  bottomRight: isUser ? Radius.zero : const Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                message.content,
                                style: GoogleFonts.comfortaa(
                                  fontSize: 16,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    })
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 120),
                        decoration: BoxDecoration(
                          color: AppColors.receiveMessageColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.sendMessageColor, width: 2),
                        ),
                        child: TextField(
                          controller: _messageController,
                          style: GoogleFonts.comfortaa(
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: GoogleFonts.comfortaa(
                              fontSize: 14,
                              color: AppColors.textColor,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send, color: AppColors.sendMessageColor),
                              onPressed: () {
                                final text = _messageController.text.trim();
                                // if (text.isNotEmpty) {
                                //   final newMessage = Message(
                                //     id: DateTime.now().millisecondsSinceEpoch.toString(),
                                //     chatId: widget.chat.id,
                                //     senderId: 'User',
                                //     content: text,
                                //     timestamp: DateTime.now(),
                                //   );
                                //   setState(() {
                                //     _chatMessages.insert(0, newMessage); // Add at start for reverse list
                                //     allMessages.add(newMessage); // Persist to global list
                                //     _messageController.clear();
                                //     // Scroll to bottom after rebuild
                                //     WidgetsBinding.instance.addPostFrameCallback((_) {
                                //       if (_scrollController.hasClients) {
                                //         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                                //       }
                                //     });
                                //   });
                                // }
                              },
                            ),
                          ),
                          cursorColor: AppColors.textColor,
                          minLines: 1,
                          maxLines: null,
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _messageList(){
    return  ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: _chatMessages.length,
      itemBuilder: (context, index) {
        final message = _chatMessages[index];
        final isUser = message.senderId == 'User';
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUser ? AppColors.sendMessageColor : AppColors.receiveMessageColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: isUser ? Radius.circular(15) : Radius.zero,
                bottomRight: isUser ? Radius.zero : Radius.circular(15),
              ),
            ),
            child: Text(
              message.content,
              style: GoogleFonts.comfortaa(
                fontSize: 16,
                color: AppColors.textColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

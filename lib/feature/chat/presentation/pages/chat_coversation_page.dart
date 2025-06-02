
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_chat_app/feature/app/const/message_list_model.dart';
import '../../../app/const/chat_list_model.dart';
import '../../../app/theme/style.dart';

class ChatConversationPage extends StatefulWidget {
  final Chat chat;

  const ChatConversationPage({super.key, required this.chat});

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<Message> _chatMessages;

  @override
  void initState() {
    super.initState();
    _chatMessages = allMessages.where((message) => message.chatId == widget.chat.id).toList();
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
                      icon: Icon(Icons.arrow_back, color: AppColors.textColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 15),
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
                      child: Center(
                        child: Text(
                          widget.chat.name.isNotEmpty ? widget.chat.name[0].toUpperCase() : '?',
                          style: GoogleFonts.comfortaa(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    widget.chat.name,
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
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: _chatMessages.isEmpty
                          ? Center(
                        child: Text(
                          'No messages yet',
                          style: GoogleFonts.comfortaa(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                      )
                          : ListView.builder(
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 120),
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
                              icon: Icon(Icons.send, color: AppColors.sendMessageColor),
                              onPressed: () {
                                final text = _messageController.text.trim();
                                if (text.isNotEmpty) {
                                  final newMessage = Message(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    chatId: widget.chat.id,
                                    senderId: 'User',
                                    content: text,
                                    timestamp: DateTime.now(),
                                  );
                                  setState(() {
                                    _chatMessages.insert(0, newMessage); // Add at start for reverse list
                                    allMessages.add(newMessage); // Persist to global list
                                    _messageController.clear();
                                    // Scroll to bottom after rebuild
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (_scrollController.hasClients) {
                                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                                      }
                                    });
                                  });
                                }
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
}

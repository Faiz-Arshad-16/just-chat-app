class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });
}

final List<Message> allMessages = [
  Message(
    id: 'm1', // Unique ID
    chatId: '1',
    senderId: 'Micheal John',
    content: 'I’ll check it, wait for a moment.',
    timestamp: DateTime.now().subtract(Duration(minutes: 2)),
  ),
  Message(
    id: 'm2',
    chatId: '1',
    senderId: 'User',
    content: 'Cool, let me know!',
    timestamp: DateTime.now().subtract(Duration(minutes: 1)),
  ),
  Message(
    id: 'm3',
    chatId: '2',
    senderId: 'Alice Smith',
    content: 'Hey, how are you?',
    timestamp: DateTime.now().subtract(Duration(minutes: 27)),
  ),
  Message(
    id: 'm4',
    chatId: '2',
    senderId: 'User',
    content:
    'Doing great, you? And what happened to that '
        'project that you were working on? '
        'Actually I am free now and if you '
        'need any help I can help you out.',
    timestamp: DateTime.now().subtract(Duration(minutes: 6)),
  ),
  Message(
    id: 'm5',
    chatId: '3',
    senderId: 'Bob Johnson',
    content: 'Let’s meet tomorrow.',
    timestamp: DateTime.now().subtract(Duration(minutes: 32)),
  ),
  Message(
    id: 'm6',
    chatId: '3',
    senderId: 'User',
    content: 'Sounds good! Where?',
    timestamp: DateTime.now().subtract(Duration(minutes: 20)),
  ),
  Message(
    id: 'm7',
    chatId: '4',
    senderId: 'Ali Sher',
    content: 'I am pashemaan',
    timestamp: DateTime.now().subtract(Duration(minutes: 12)),
  ),
  Message(
    id: 'm8',
    chatId: '4',
    senderId: 'User',
    content: 'Koi baat nahi!',
    timestamp: DateTime.now().subtract(Duration(minutes: 3)),
  ),
  Message(
    id: 'm9',
    chatId: '5',
    senderId: 'Aziz Bhai',
    content: 'Thanks for the help!',
    timestamp: DateTime.now().subtract(Duration(minutes: 22)),
  ),
  Message(
    id: 'm10',
    chatId: '5',
    senderId: 'User',
    content: 'Anytime!',
    timestamp: DateTime.now().subtract(Duration(minutes: 10)),
  ),
];
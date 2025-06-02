class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final String lastMessageTime;
  final String? profileImage;

  Chat({
    required this.id,
    this.lastMessage = "No messages yet",
    required this.lastMessageTime,
    this.profileImage,
    required this.name,
  });
}

final List<Chat> allChats = [
  Chat(
    id: "1",
    name: "Micheal John",
    lastMessage: "I'll check it, wait for a moment and get back to you",
    lastMessageTime: '2 min ago',
    profileImage: null,
  ),
  Chat(
    id: "2",
    name: "Alice Smith",
    lastMessage: "Hey, how are you?",
    lastMessageTime: '10 min ago',
    profileImage: null,
  ),
  Chat(
    id: "3",
    name: "Bob Johnson",
    lastMessage: "Let's meet tomorrow.",
    lastMessageTime: '2 hr ago',
    profileImage: null,
  ),
  Chat(
    id: "4",
    name: "Ali Sher",
    lastMessage: "I am pashemaan",
    lastMessageTime: '23 min ago',
    profileImage: null,
  ),
  Chat(
    id: "5",
    name: "Aziz Bhai",
    lastMessage: "Thanks for the help!",
    lastMessageTime: 'now',
    profileImage: null,
  ),
  Chat(
    id: "6",
    name: "Bilal",
    lastMessage: "VSCode is HARAM!!!",
    lastMessageTime: 'yesterday',
    profileImage: null,
  ),
  Chat(
    id: "7",
    name: "Kamran",
    lastMessage: "q nai ho rahi parhayi?",
    lastMessageTime: '12 hr ago',
    profileImage: null,
  ),
  Chat(
    id: "8",
    name: "Mudassir",
    lastMessage: "ya to win hai, ya to learn hai",
    lastMessageTime: '2 min ago',
    profileImage: null,
  ),
  Chat(
    id: "9",
    name: "Waleed",
    lastMessage: "Chutti ki application likho",
    lastMessageTime: '5 hr ago',
    profileImage: null,
  ),
  Chat(
    id: "10",
    name: "Haris",
    lastMessage: "Meri tabiyat kharab hai",
    lastMessageTime: '1 week ago',
    profileImage: null,
  ),
  Chat(
    id: "11",
    name: "Hashim",
    lastMessage: "k karny Massairrrr???",
    lastMessageTime: '3 days ago',
    profileImage: null,
  ),
  Chat(
    id: "12",
    name: "Sad Abdullah",
    lastMessageTime: '2 month ago',
    profileImage: null,
  ),
  Chat(
    id: "13",
    name: "Khan",
    lastMessageTime: '2 weeks ago',
    profileImage: null,
  ),
  Chat(
    id: "14",
    name: "Kunda",
    lastMessageTime: '2 weeks ago',
    profileImage: null,
  ),
  Chat(
    id: "15",
    name: "Maaz",
    lastMessageTime: '2 weeks ago',
    profileImage: null,
  ),
];

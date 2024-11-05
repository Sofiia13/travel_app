import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({
    super.key,
    required this.journeyId,
  });

  final String journeyId;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final myController = TextEditingController();
  List<types.Message> _messages = [];
  late final types.User _user;

  @override
  void initState() {
    super.initState();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    _user = types.User(id: currentUserId, firstName: currentUserEmail);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _addMessage(String text) {
    final message = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
    );

    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chat(
                messages: _messages,
                onSendPressed: (types.PartialText message) {
                  _addMessage(message.text);
                },
                user: _user,
                showUserNames: true,
                theme: DefaultChatTheme(
                  inputBackgroundColor:
                      const Color.fromARGB(255, 158, 193, 253),
                  inputTextColor: Colors.white,
                  inputBorderRadius:
                      BorderRadius.circular(30), // Rounded input field
                  messageBorderRadius: 15, // Border radius for messages
                  primaryColor: Theme.of(context)
                      .colorScheme
                      .primary, // Color for user's messages
                  secondaryColor: const Color.fromARGB(
                      255, 200, 200, 200), // Color for other users' messages
                  // userAvatarNameColors: [Colors.blue, Colors.green],
                  // backgroundColor: Colors.white, // Chat background color
                  // messageTextStyle: TextStyle(
                  //   color: Colors.black87, // Text color in messages
                  //   fontSize: 16,
                  // ),
                  dateDividerTextStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  userNameTextStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600, // Bold user names
                  ),
                ),
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          // child: Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(
          //         30), // Larger radius for rounded edges
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.grey.withOpacity(0.3),
          //         spreadRadius: 2,
          //         blurRadius: 5,
          //         offset: Offset(0, 2),
          //       ),
          //     ],
          //   ),

          // child: TextField(
          //   controller: myController,
          //   decoration: InputDecoration(
          //     border: InputBorder.none,
          //     hintText: 'Enter a comment',
          //     contentPadding:
          //         EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          //     suffixIcon: IconButton(
          //       onPressed: () {
          //         if (myController.text.isNotEmpty) {
          //           _addMessage(myController.text);
          //           myController.clear();
          //         }
          //       },
          //       icon: Icon(Icons.send,
          //           color: Colors.blueAccent), // Custom color for send icon
          //     ),
          //   ),
          // ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

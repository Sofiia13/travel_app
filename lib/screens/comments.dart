import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_database/firebase_database.dart';

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
  late final DatabaseReference _messagesRef;
  final myController = TextEditingController();
  List<types.Message> _messages = [];
  late final types.User _user;

  @override
  void initState() {
    super.initState();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    _user = types.User(id: currentUserId, firstName: currentUserEmail);

    _messagesRef =
        FirebaseDatabase.instance.ref().child('messages/${widget.journeyId}');

    _loadMessages();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _loadMessages() async {
    try {
      DataSnapshot snapshot =
          await _messagesRef.orderByChild('createdAt').get();
      if (snapshot.exists) {
        final messagesData = snapshot.value as Map<dynamic, dynamic>;
        List<types.Message> loadedMessages = [];
        messagesData.forEach((key, value) {
          final message = types.TextMessage(
            id: value['id'],
            text: value['text'],
            author: types.User(
              id: value['author']['id'],
              firstName: value['author']['firstName'],
            ),
            createdAt: value['createdAt'],
          );
          loadedMessages.add(message);
        });

        setState(() {
          _messages = loadedMessages
            ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        });
      } else {
        print("No messages found");
      }
    } catch (e) {
      print("Error loading messages: $e");
    }
  }

  void _addMessage(String text) {
    if (text.isNotEmpty) {
      final message = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().millisecondsSinceEpoch.toString() + _user.id,
        text: text,
      );

      _messagesRef.push().set({
        'id': message.id,
        'text': message.text,
        'author': {
          'id': _user.id,
          'firstName': _user.firstName,
        },
        'createdAt': message.createdAt,
      }).then((_) {
        setState(() {
          _messages.insert(0, message);
        });
        myController.clear();
      }).catchError((error) {
        print("Failed to send message: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  inputBorderRadius: BorderRadius.circular(30),
                  messageBorderRadius: 15,
                  primaryColor: Theme.of(context).colorScheme.primary,
                  secondaryColor: const Color.fromARGB(255, 200, 200, 200),
                  dateDividerTextStyle: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                  userNameTextStyle: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

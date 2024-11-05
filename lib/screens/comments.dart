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

    // Set the reference to the specific journey's messages
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
          // Sort messages in chronological order and reverse the order to display the newest first
          _messages = loadedMessages
            ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        });
      } else {
        print("No messages found");
      }
    } catch (e) {
      print("Error loading messages: $e");
    }

    // Listen for new messages
    _messagesRef.onChildAdded.listen((event) {
      try {
        final messageData = event.snapshot.value as Map<dynamic, dynamic>;
        final message = types.TextMessage(
          id: messageData['id'],
          text: messageData['text'],
          author: types.User(
            id: messageData['author']['id'],
            firstName: messageData['author']['firstName'],
          ),
          createdAt: messageData['createdAt'],
        );

        // setState(() {
        //   // Insert the new message at the top and reverse the list
        //   _messages.insert(
        //       0, message); // Insert at the top for the reverse order
        // });
      } catch (e) {
        print("Error handling new message: $e");
      }
    });
  }

  void _addMessage(String text) {
    if (text.isNotEmpty) {
      final message = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().millisecondsSinceEpoch.toString() +
            _user.id, // Unique ID
        text: text,
      );

      // Push the new message to Firebase
      _messagesRef.push().set({
        'id': message.id,
        'text': message.text,
        'author': {
          'id': _user.id,
          'firstName': _user.firstName,
        },
        'createdAt': message.createdAt,
      }).then((_) {
        // Add to local state after successfully sending
        setState(() {
          _messages.insert(0, message); // Insert new message at the top
        });
        myController.clear(); // Clear input field after sending
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

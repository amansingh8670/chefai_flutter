import 'package:chef_ai_mobile/features/chatbot/widgets/chat_bubble.dart';
import 'package:chef_ai_mobile/features/chatbot/widgets/chat_input.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat-screen';

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: 10, // Placeholder data
                itemBuilder: (context, index) {
                  return ChatBubble(
                    message: 'Placeholder message',
                    isFromCurrentUser: index % 2 == 0,
                  );
                },
              ),
            ),
            ChatInput(),
          ],
        ),
      ),
    );
  }
}
import 'package:chef_ai_mobile/shared/widgets/inputs/text_field.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
             child: AppTextField(
              label: "Item Name",
              hint: "e.g. Organic Brown Eggs",
              controller: _controller,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Handle send button press
            },
          ),
        ],
      ),
    );
  }
}
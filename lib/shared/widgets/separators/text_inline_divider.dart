import 'package:flutter/material.dart';

class TextInlineDivider extends StatelessWidget {
  final String text;
  const TextInlineDivider({super.key, this.text = ""});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 2, color: Colors.grey)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w700),
          ),
        ),
        const Expanded(child: Divider(thickness: 2, color: Colors.grey)),
      ],
    );
  }
}

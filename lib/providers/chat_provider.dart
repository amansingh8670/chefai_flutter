import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_provider.dart';

class ChatMessage {
  final String id;
  final String role;
  final String content;

  ChatMessage({required this.id, required this.role, required this.content});
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatState({required this.messages, this.isLoading = false});

  ChatState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref ref;

  ChatNotifier(this.ref) : super(ChatState(messages: [
    ChatMessage(
      id: 'init', 
      role: 'assistant', 
      content: 'Hi! I am ChefAI. How can I help you in the kitchen today?'
    )
  ]));

  void addMessage(ChatMessage message) {
    state = state.copyWith(messages: [...state.messages, message]);
  }

  void appendToLastMessage(String chunk) {
    if (state.messages.isEmpty) return;
    
    final lastMsg = state.messages.last;
    if (lastMsg.role == 'assistant') {
      final updatedMsg = ChatMessage(
        id: lastMsg.id,
        role: lastMsg.role,
        content: lastMsg.content + chunk,
      );
      
      final newMessages = List<ChatMessage>.from(state.messages);
      newMessages[newMessages.length - 1] = updatedMsg;
      
      state = state.copyWith(messages: newMessages);
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: text,
    );
    addMessage(userMsg);
    
    // Add empty assistant message to stream into
    final assistantMsgId = 'asst_${DateTime.now().millisecondsSinceEpoch}';
    addMessage(ChatMessage(id: assistantMsgId, role: 'assistant', content: ''));
    
    state = state.copyWith(isLoading: true);

    try {
      final apiClient = ref.read(apiClientProvider);
      final session = Supabase.instance.client.auth.currentSession;
      final userId = session?.user.id ?? 'demo';
      
      final url = Uri.parse('${apiClient.baseUrl}/chat/');
      final request = http.Request('POST', url);
      
      request.headers.addAll({
        'Content-Type': 'application/json',
        if (session != null) 'Authorization': 'Bearer ${session.accessToken}',
      });
      
      request.body = jsonEncode({
        'user_id': userId,
        'message': text,
        'context': {}
      });

      final client = http.Client();
      final response = await client.send(request);
      
      if (response.statusCode != 200) {
         appendToLastMessage('\n\n[Error communicating with ChefAI]');
         state = state.copyWith(isLoading: false);
         return;
      }

      // Read SSE stream
      response.stream.transform(utf8.decoder).listen((data) {
        // SSE data comes as "data: {json}\n\n"
        final lines = data.split('\n');
        for (var line in lines) {
          if (line.startsWith('data: ')) {
            final jsonStr = line.substring(6).trim();
            if (jsonStr == '[DONE]') continue;
            
            try {
              final json = jsonDecode(jsonStr);
              if (json['type'] == 'token' && json['content'] != null) {
                appendToLastMessage(json['content']);
              } else if (json['type'] == 'error') {
                appendToLastMessage('\n\n[Error: ${json['content']}]');
              } else if (json['type'] == 'done') {
                // Done
              }
            } catch (e) {
               // ignore partial json chunk parsing errors
            }
          }
        }
      }, onDone: () {
        state = state.copyWith(isLoading: false);
        client.close();
      }, onError: (err) {
        state = state.copyWith(isLoading: false);
        client.close();
      });

    } catch (e) {
      state = state.copyWith(isLoading: false);
      appendToLastMessage('\n\n[Connection Error]');
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref);
});

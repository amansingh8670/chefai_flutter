import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/chat_provider.dart';

class ParsedVideo {
  final String title;
  final String videoUrl;
  final String channel;
  final String thumbnailUrl;

  ParsedVideo(this.title, this.videoUrl, this.channel, this.thumbnailUrl);
}

class ParsedMessage {
  final String cleanText;
  final List<String> videoSuggestions;
  final List<String> quickReplies;
  final List<ParsedVideo> ytVideos;

  ParsedMessage(this.cleanText, this.videoSuggestions, this.quickReplies, this.ytVideos);
}

ParsedMessage parseMessageTags(String rawText) {
  String cleanText = rawText;
  final List<String> videoSuggestions = [];
  final List<String> quickReplies = [];
  final List<ParsedVideo> ytVideos = [];

  final videoRegExp = RegExp(r'<<VIDEO_SUGGESTION:\s*(.*?)>>', dotAll: true);
  for (final match in videoRegExp.allMatches(rawText)) {
    videoSuggestions.add(match.group(1)!.replaceAll('\n', ' ').trim());
  }
  cleanText = cleanText.replaceAll(videoRegExp, '');

  final quickRegExp = RegExp(r'<<QUICK_REPLIES:\s*(.*?)>>', dotAll: true);
  for (final match in quickRegExp.allMatches(rawText)) {
    final repliesRaw = match.group(1)!;
    quickReplies.addAll(repliesRaw.split('|').map((e) => e.replaceAll('\n', ' ').trim()).where((e) => e.isNotEmpty));
  }
  cleanText = cleanText.replaceAll(quickRegExp, '');

  // Format 1: [Title](vid.url) by Channel \n ![alt](img.jpg)
  final ytRegExp1 = RegExp(
    r'(?:\d+\.\s*)?\[(.*?)\]\((https:\/\/[^\)]*?youtube\.com[^\)]*?)\)(?:\s*by\s*([^\n!]*?))?\s*!\[.*?\]\((https:\/\/i\.ytimg\.com[^\)]*?)\)',
    dotAll: true
  );
  
  for (final match in ytRegExp1.allMatches(rawText)) {
    ytVideos.add(ParsedVideo(
      match.group(1)!.trim(),
      match.group(2)!.trim(),
      match.group(3)?.trim() ?? 'YouTube',
      match.group(4)!.trim()
    ));
  }
  cleanText = cleanText.replaceAll(ytRegExp1, '');

  // Format 2: Title by Channel \n ![alt](img.jpg) \n [Watch Video](vid.url)
  final ytRegExp2 = RegExp(
    r'(?:^|\n)([^\n]*?)\n\s*!\[[^\]]*\]\((https:\/\/i\.ytimg\.com[^\)]*?)\)\n\s*\[[^\]]*\]\((https:\/\/(?:www\.)?youtube\.com[^\)]*?)\)'
  );

  for (final match in ytRegExp2.allMatches(cleanText)) {
    String titleAndChannel = match.group(1)!.trim();
    titleAndChannel = titleAndChannel.replaceFirst(RegExp(r'^\d+\.\s*'), '');
    
    String title = titleAndChannel;
    String channel = 'YouTube';
    if (titleAndChannel.contains(' by ')) {
      final parts = titleAndChannel.split(' by ');
      channel = parts.last.trim();
      title = parts.sublist(0, parts.length - 1).join(' by ').trim();
    }
    
    ytVideos.add(ParsedVideo(
      title,
      match.group(3)!.trim(),
      channel,
      match.group(2)!.trim()
    ));
  }
  cleanText = cleanText.replaceAll(ytRegExp2, '');

  // Hide partial tags that are still streaming in (including newlines)
  cleanText = cleanText.replaceAll(RegExp(r'<<[^>]*$', dotAll: true), '');
  // Hide partial markdown image/links tags that are still streaming in
  cleanText = cleanText.replaceAll(RegExp(r'!\[[^\]]*$', dotAll: true), '');
  cleanText = cleanText.replaceAll(RegExp(r'\[[^\]]*$', dotAll: true), '');

  return ParsedMessage(cleanText.trim(), videoSuggestions, quickReplies, ytVideos);
}

class ChatScreen extends ConsumerStatefulWidget {
  static const routeName = '/chat-screen';
  final VoidCallback? onBack;

  const ChatScreen({super.key, this.onBack});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    ref.read(chatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF111315);
    final chatState = ref.watch(chatProvider);
    
    // Auto scroll when new messages arrive
    ref.listen(chatProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length || next.isLoading) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                       if (widget.onBack != null) {
                         widget.onBack!();
                       } else if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                       }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                  
                  // Title
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/chefai_logo.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(AppColors.primaryOrange, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'ChefAI Bot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  
                  // Help Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.question_mark_rounded, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),

            // Chat Content
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                physics: const BouncingScrollPhysics(),
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatState.messages[index];
                  final isUser = msg.role == 'user';
                  final parsed = isUser ? ParsedMessage(msg.content, [], [], []) : parseMessageTags(msg.content);
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          // Bot Avatar
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryOrange.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/chefai_logo.svg',
                                height: 28,
                                width: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        
                        // Bubble and Suggestions
                        Flexible(
                          child: Column(
                            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              if (!isUser) ...[
                                const Text(
                                  'CHEFAI BOT',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                              ],
                              
                              if (parsed.cleanText.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isUser ? AppColors.primaryOrange : const Color(0xFF1E2124),
                                    borderRadius: BorderRadius.circular(16).copyWith(
                                      topLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                                      topRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    parsed.cleanText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              
                              // YouTube Videos
                              if (parsed.ytVideos.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: parsed.ytVideos.map((video) {
                                      return _buildYoutubeCard(video);
                                    }).toList(),
                                  ),
                                ),
                              
                              // Video Suggestions
                              if (parsed.videoSuggestions.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: parsed.videoSuggestions.map((video) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Placeholder for actual video play logic
                                          _sendMessage("Play video: $video");
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.play_circle_fill_rounded, color: Colors.redAccent, size: 20),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  video,
                                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),

                              // Quick Replies
                              if (parsed.quickReplies.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: parsed.quickReplies.map((reply) {
                                      return GestureDetector(
                                        onTap: () => _sendMessage(reply),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundDark,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: AppColors.primaryOrange),
                                          ),
                                          child: Text(
                                            reply,
                                            style: const TextStyle(color: AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        if (isUser) const SizedBox(width: 44 + 12), // Balance avatar width
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Quick Suggestions & Input
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (chatState.messages.length < 3) ...[
                    const Text(
                      'QUICK SUGGESTIONS',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Suggestion List
                    _buildSuggestionItem('What can I cook with my stock?'),
                    const SizedBox(height: 8),
                    _buildSuggestionItem('Suggest a healthy dinner'),
                    const SizedBox(height: 8),
                    _buildSuggestionItem('Show me a pasta recipe'),
                    const SizedBox(height: 8),
                    _buildSuggestionItem('How do I scan a bill?'),
                    const SizedBox(height: 16),
                  ],
                  
                  // Text Input
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.only(left: 20, right: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            onSubmitted: _sendMessage,
                            decoration: const InputDecoration(
                              hintText: 'Message ChefAI for recipes, stock advice...',
                              hintStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _sendMessage(_textController.text),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange,
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: chatState.isLoading 
                              ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String text) {
    return GestureDetector(
      onTap: () => _sendMessage(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.primaryOrange,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYoutubeCard(ParsedVideo video) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(video.videoUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        width: 240,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  video.thumbnailUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: Colors.black45,
                    child: const Center(child: Icon(Icons.broken_image, color: Colors.white24)),
                  ),
                ),
                Container(
                  height: 140,
                  color: Colors.black26,
                ),
                const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 48),
              ],
            ),
            // Title & Channel
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.channel,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
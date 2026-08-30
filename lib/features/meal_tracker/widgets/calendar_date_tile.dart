import 'package:flutter/material.dart';

class CalendarDateTile extends StatelessWidget {
  final String day;
  final String date;
  final bool selected;
  final bool showIndicator;

  const CalendarDateTile({
    super.key,
    required this.day,
    required this.date,
    this.selected = false,
    this.showIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical : 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: selected ? Colors.deepOrange : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              date,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedOpacity(
            opacity: showIndicator ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
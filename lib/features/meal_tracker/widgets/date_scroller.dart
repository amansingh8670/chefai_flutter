import 'package:flutter/material.dart';
import 'calendar_date_tile.dart';

class DateScroller extends StatelessWidget {
  final List<String> days;
  final List<String> dates;
  final int selectedIndex;

  const DateScroller({
    super.key,
    required this.days,
    required this.dates,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          return CalendarDateTile(
            day: days[index],
            date: dates[index],
            selected: index == selectedIndex,
            showIndicator: index == selectedIndex,
          );
        },
      ),
    );
  }
}
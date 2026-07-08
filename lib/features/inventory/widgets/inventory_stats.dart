import 'package:flutter/material.dart';

class InventoryStats extends StatelessWidget {
  final List<InventoryStatItem> stats;

  const InventoryStats({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: _StatCard(
            title: stat.title,
            value: stat.value,
            color: stat.color,
          ),
        );
      }).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.all(10),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 8,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryStatItem {
  final String title;
  final String value;
  final Color color;

  const InventoryStatItem({
    required this.title,
    required this.value,
    required this.color,
  });
}
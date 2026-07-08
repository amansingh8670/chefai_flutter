import 'package:flutter/material.dart';

class AvailableItemCard extends StatelessWidget {
  final String imageUrl;
  final String expirationStatus;
  final String quantity;
  final String itemName;

  const AvailableItemCard({
    super.key,
    required this.imageUrl,
    required this.expirationStatus,
    required this.quantity,
    required this.itemName,
  });

  Color _expirationColor() {
    switch (expirationStatus.toLowerCase()) {
      case 'fresh':
        return Colors.green;
      case 'expiring soon':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.image_not_supported,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _expirationColor().withOpacity(.85),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      expirationStatus,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            itemName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            quantity,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
class InventoryItem {
  final String name;
  final String imageUrl;
  final String expirationStatus;
  final String quantity;

  const InventoryItem({
    required this.name,
    required this.imageUrl,
    required this.expirationStatus,
    required this.quantity,
  });
}
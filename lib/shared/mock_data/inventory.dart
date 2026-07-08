import 'package:chef_ai_mobile/shared/models/inventory_category.dart';
import 'package:chef_ai_mobile/shared/models/inventory_item.dart';

class InventoryMockData {
  static const List<InventoryCategory> categories = [
    InventoryCategory(
      id: "fresh",
      icon: "🥬",
      name: "Fresh\nVeg",
    ),
    InventoryCategory(
      id: "leafy",
      icon: "🌿",
      name: "Leafy",
    ),
    InventoryCategory(
      id: "exotic",
      icon: "🍆",
      name: "Exotic",
    ),
    InventoryCategory(
      id: "organic",
      icon: "🍅",
      name: "Organic",
    ),
    InventoryCategory(
      id: "roots",
      icon: "🥕",
      name: "Roots",
    ),
    InventoryCategory(
      id: "fruits",
      icon: "🍎",
      name: "Fruits",
    ),
    InventoryCategory(
      id: "herbs",
      icon: "🌱",
      name: "Herbs",
    ),
    InventoryCategory(
      id: "mushrooms",
      icon: "🍄",
      name: "Mushrooms",
    ),
    InventoryCategory(
      id: "premium",
      icon: "🥑",
      name: "Premium",
    ),
    InventoryCategory(
      id: "festive",
      icon: "🌸",
      name: "Festive",
    ),
    InventoryCategory(
      id: "spices",
      icon: "🧄",
      name: "Spices",
    ),
    InventoryCategory(
      id: "others",
      icon: "🛒",
      name: "Others",
    ),
  ];

  static const List<InventoryItem> items = [
    InventoryItem(
      name: "Cucumber",
      imageUrl: "https://picsum.photos/seed/1/300",
      expirationStatus: "Fresh",
      quantity: "3 pcs",
    ),
    InventoryItem(
      name: "Bottle Gourd",
      imageUrl: "https://picsum.photos/seed/2/300",
      expirationStatus: "Expiring Soon",
      quantity: "1 kg",
    ),
    InventoryItem(
      name: "Spinach",
      imageUrl: "https://picsum.photos/seed/3/300",
      expirationStatus: "Fresh",
      quantity: "500 g",
    ),
    InventoryItem(
      name: "Broccoli",
      imageUrl: "https://picsum.photos/seed/4/300",
      expirationStatus: "Fresh",
      quantity: "2 pcs",
    ),
    InventoryItem(
      name: "Carrot",
      imageUrl: "https://picsum.photos/seed/5/300",
      expirationStatus: "Fresh",
      quantity: "1 kg",
    ),
    InventoryItem(
      name: "Tomato",
      imageUrl: "https://picsum.photos/seed/6/300",
      expirationStatus: "Expiring Soon",
      quantity: "8 pcs",
    ),
    InventoryItem(
      name: "Potato",
      imageUrl: "https://picsum.photos/seed/7/300",
      expirationStatus: "Fresh",
      quantity: "2 kg",
    ),
    InventoryItem(
      name: "Onion",
      imageUrl: "https://picsum.photos/seed/8/300",
      expirationStatus: "Fresh",
      quantity: "2 kg",
    ),
    InventoryItem(
      name: "Bell Pepper",
      imageUrl: "https://picsum.photos/seed/9/300",
      expirationStatus: "Fresh",
      quantity: "4 pcs",
    ),
    InventoryItem(
      name: "Cauliflower",
      imageUrl: "https://picsum.photos/seed/10/300",
      expirationStatus: "Fresh",
      quantity: "1 pc",
    ),
    InventoryItem(
      name: "Cabbage",
      imageUrl: "https://picsum.photos/seed/11/300",
      expirationStatus: "Fresh",
      quantity: "1 pc",
    ),
    InventoryItem(
      name: "Eggplant",
      imageUrl: "https://picsum.photos/seed/12/300",
      expirationStatus: "Fresh",
      quantity: "700 g",
    ),
    InventoryItem(
      name: "Green Chilli",
      imageUrl: "https://picsum.photos/seed/13/300",
      expirationStatus: "Fresh",
      quantity: "250 g",
    ),
    InventoryItem(
      name: "Garlic",
      imageUrl: "https://picsum.photos/seed/14/300",
      expirationStatus: "Fresh",
      quantity: "250 g",
    ),
    InventoryItem(
      name: "Ginger",
      imageUrl: "https://picsum.photos/seed/15/300",
      expirationStatus: "Fresh",
      quantity: "300 g",
    ),
    InventoryItem(
      name: "Mushroom",
      imageUrl: "https://picsum.photos/seed/16/300",
      expirationStatus: "Expiring Soon",
      quantity: "250 g",
    ),
    InventoryItem(
      name: "Mint Leaves",
      imageUrl: "https://picsum.photos/seed/17/300",
      expirationStatus: "Fresh",
      quantity: "2 bunch",
    ),
    InventoryItem(
      name: "Coriander",
      imageUrl: "https://picsum.photos/seed/18/300",
      expirationStatus: "Fresh",
      quantity: "2 bunch",
    ),
    InventoryItem(
      name: "Lemon",
      imageUrl: "https://picsum.photos/seed/19/300",
      expirationStatus: "Fresh",
      quantity: "6 pcs",
    ),
    InventoryItem(
      name: "Apple",
      imageUrl: "https://picsum.photos/seed/20/300",
      expirationStatus: "Fresh",
      quantity: "5 pcs",
    ),
    InventoryItem(
      name: "Orange",
      imageUrl: "https://picsum.photos/seed/21/300",
      expirationStatus: "Fresh",
      quantity: "6 pcs",
    ),
    InventoryItem(
      name: "Banana",
      imageUrl: "https://picsum.photos/seed/22/300",
      expirationStatus: "Fresh",
      quantity: "12 pcs",
    ),
    InventoryItem(
      name: "Avocado",
      imageUrl: "https://picsum.photos/seed/23/300",
      expirationStatus: "Fresh",
      quantity: "2 pcs",
    ),
    InventoryItem(
      name: "Beetroot",
      imageUrl: "https://picsum.photos/seed/24/300",
      expirationStatus: "Fresh",
      quantity: "1 kg",
    ),
    InventoryItem(
      name: "Sweet Corn",
      imageUrl: "https://picsum.photos/seed/25/300",
      expirationStatus: "Fresh",
      quantity: "3 pcs",
    ),
    InventoryItem(
      name: "Radish",
      imageUrl: "https://picsum.photos/seed/26/300",
      expirationStatus: "Fresh",
      quantity: "500 g",
    ),
    InventoryItem(
      name: "Celery",
      imageUrl: "https://picsum.photos/seed/27/300",
      expirationStatus: "Fresh",
      quantity: "1 bunch",
    ),
    InventoryItem(
      name: "Pumpkin",
      imageUrl: "https://picsum.photos/seed/28/300",
      expirationStatus: "Fresh",
      quantity: "2 kg",
    ),
    InventoryItem(
      name: "Zucchini",
      imageUrl: "https://picsum.photos/seed/29/300",
      expirationStatus: "Fresh",
      quantity: "3 pcs",
    ),
    InventoryItem(
      name: "Asparagus",
      imageUrl: "https://picsum.photos/seed/30/300",
      expirationStatus: "Fresh",
      quantity: "250 g",
    ),
  ];
}
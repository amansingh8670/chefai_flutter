import 'package:chef_ai_mobile/shared/models/inventory_category.dart';
import 'package:chef_ai_mobile/shared/models/inventory_item.dart';


class InventoryMockData {

  static const categories = [

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
      id: "festive",
      icon: "🌸",
      name: "Festive",
    ),

    InventoryCategory(
      id: "premium",
      icon: "🥑",
      name: "Premium",
    ),

  ];


  static const items = [

    InventoryItem(
      name: "Cucumber",
      imageUrl:
          "https://placehold.co/300x300/png?text=Cucumber",
      expirationStatus: "Fresh",
      quantity: "3 pcs",
    ),

    InventoryItem(
      name: "Bottle Gourd",
      imageUrl:
          "https://placehold.co/300x300/png?text=Gourd",
      expirationStatus: "Expiring Soon",
      quantity: "1 kg",
    ),

    InventoryItem(
      name: "Spinach",
      imageUrl:
          "https://placehold.co/300x300/png?text=Spinach",
      expirationStatus: "Fresh",
      quantity: "500 g",
    ),

  ];
}
class ApiConstants {
  // Use dotenv for the base URL in api_client, but define endpoints here.
  
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/users/me';
  
  // Kitchen Inventory
  static const String kitchenInventory = '/kitchens/inventory';
  static const String kitchenScan = '/kitchens/scan';
  
  // Meals
  static const String meals = '/meals';
  static const String mealsRecommend = '/meals/recommend';
  
  // Shopping
  static const String shoppingCart = '/shopping/cart';
}

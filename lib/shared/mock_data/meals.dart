import '../models/detected_meal.dart';
class MealsMockData {
  static const  List<DetectedMeal> meals = [
    DetectedMeal(
      id: "1",
      imagePath: "assets/images/salmon.jpg",
      name: "Grilled Salmon Fillet",
      quantityUnit: "KG",
      mealType: "Dinner",
      calories: 480,
      carbs: 10,
      protein: 45,
      fat: 22,
      quantity: 1,
      ingredients: [
        "Dine Out",
        "Salmon",
        "Olive Oil",
        "Garlic",
        "Lemon",
      ],
    ),

    DetectedMeal(
      id: "2",
      imagePath: "assets/images/egg_noodles.jpg",
      name: "Egg Noodles",
      quantityUnit: "pc",
      mealType: "Lunch",
      calories: 380,
      carbs: 52,
      protein: 18,
      fat: 11,
      quantity: 1,
      ingredients: [
        "Home Cooked",
        "Egg",
        "Noodles",
        "Soy Sauce",
      ],
    ),

    DetectedMeal(
      id: "3",
      imagePath: "assets/images/fried_rice.jpg",
      name: "Chicken Fried Rice",
      quantityUnit: "pc",
      mealType: "Lunch",
      calories: 520,
      carbs: 58,
      protein: 30,
      fat: 15,
      quantity: 2,
      ingredients: [
        "Chicken",
        "Rice",
        "Egg",
        "Peas",
        "Carrot",
      ],
    ),

    DetectedMeal(
      id: "4",
      imagePath: "assets/images/pasta.jpg",
      name: "Creamy Alfredo Pasta",
      quantityUnit: "KG",
      mealType: "Dinner",
      calories: 610,
      carbs: 65,
      protein: 19,
      fat: 28,
      quantity: 1,
      ingredients: [
        "Pasta",
        "Cream",
        "Cheese",
        "Butter",
      ],
    ),

    DetectedMeal(
      id: "5",
      imagePath: "assets/images/veg_bowl.jpg",
      name: "Healthy Veg Bowl",
      quantityUnit: "KG",
      mealType: "Breakfast",
      calories: 310,
      carbs: 28,
      protein: 16,
      fat: 8,
      quantity: 1,
      ingredients: [
        "Avocado",
        "Corn",
        "Broccoli",
        "Beans",
        "Spinach",
      ],
    ),
  ];

}
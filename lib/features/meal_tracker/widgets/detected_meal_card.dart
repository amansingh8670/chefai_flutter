import 'package:flutter/material.dart';

class DetectedMealCard extends StatelessWidget {
  final String imagePath;
  final String mealName;
  final String mealType;
  final int calories;
  final int carbs;
  final int protein;
  final int fat;
  final List<String> ingredients;
  final int quantity;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const DetectedMealCard({
    super.key,
    required this.imagePath,
    required this.mealName,
    required this.mealType,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.ingredients,
    required this.quantity,
    this.onEdit,
    this.onRemove,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 285,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff1C1E26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xffFF8A24).withValues(alpha: .25),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  imagePath,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 68,
                    height: 68,
                    color: Colors.grey.shade800,
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      mealType.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: .55),
                        letterSpacing: .5,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: .20),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _NutritionChip(
                label: "$calories kcal",
                color: Colors.orange,
              ),
              const SizedBox(width: 6),
              _NutritionChip(
                label: "C:${carbs}g",
                color: Colors.blueGrey,
              ),
              const SizedBox(width: 6),
              _NutritionChip(
                label: "P:${protein}g",
                color: Colors.green,
              ),
              const SizedBox(width: 6),
              _NutritionChip(
                label: "F:${fat}g",
                color: Colors.pinkAccent,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...ingredients.take(2).map(
                (e) => _IngredientChip(label: e),
              ),
              if (ingredients.length > 2)
                _IngredientChip(
                  label: "+${ingredients.length - 2}",
                  background: Colors.grey.shade700,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                "QTY",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .12),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onDecrement,
                      icon: const Icon(
                        Icons.remove,
                        size: 16,
                      ),
                      color: Colors.white,
                      visualDensity: VisualDensity.compact,
                    ),
                    Text(
                      "$quantity",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: onIncrement,
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                      ),
                      color: Colors.white,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "portion",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: onEdit,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(70, 34),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: .15),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("EDIT"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutritionChip extends StatelessWidget {
  final String label;
  final Color color;

  const _NutritionChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  final String label;
  final Color? background;

  const _IngredientChip({
    required this.label,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background ?? const Color(0xff2A2D37),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
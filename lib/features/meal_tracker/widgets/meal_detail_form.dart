import 'package:flutter/material.dart';

class MealDetailForm extends StatelessWidget {
  const MealDetailForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meal Details')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Horizontal layout for text input and dropdown
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'e.g. Chicken Biryani Platter'),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  // Add your dropdown items here
                  items: [],
                  onChanged: (String? newValue) {
                    // Handle the dropdown value change here
                  },
                ),
              ],
            ),
            // Horizontal layout for text input
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Preparation Type'),
                  ),
                ),
              ],
            ),
            // Section for macronutrients
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Macronutrients (Grouped)'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      child: Text('+ Auto Calculate'),
                      onPressed: () {
                        // Handle button press here
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Calories (KCAL)'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Protein (G)'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Carbohydrates (G)'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Fat (G)'),
                    ),
                  ],
                ),
              ],
            ),
            // Section for ingredients list
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ingredients List'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Add ingredient (e.g. Basmati Rice)'),
                    ),
                    ElevatedButton(
                      child: Text('+ Add'),
                      onPressed: () {
                        // Handle button press here
                      },
                    ),
                  ],
                ),
              ],
            ),
            // Action button
            ElevatedButton(
              child: Text('Add Meal to Scan Queue'),
              onPressed: () {
                // Handle button press here
              },
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:chef_ai_mobile/shared/mock_data/inventory.dart';
// import 'package:flutter/material.dart';

// class SmartCartScreen extends StatelessWidget {
//   const SmartCartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Smart Cart'),
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Smart Cart'),
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     // handle deselect all action
//                   },
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: InventoryMockData.categories.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(InventoryMockData.categories[index].name),
//                     subtitle: Text('Available on InstaMart - ₹55'),
//                     trailing: IconButton(
//                       icon: Icon(Icons.shopping_cart),
//                       onPressed: () {
//                         // handle buy action
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Text('Total: ₹166'),
//             ElevatedButton(
//               child: Text('Confirm Auto-Refill'),
//               onPressed: () {
//                 // handle confirm auto-refill action
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:chef_ai_mobile/shared/mock_data/inventory.dart';
import 'package:flutter/material.dart';
// import 'inventory.dart';

class SmartCartScreen extends StatelessWidget {
  const SmartCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Cart'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Smart Cart'),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // handle deselect all action
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: InventoryMockData.categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(InventoryMockData.categories[index].name),
                    leading: Text(InventoryMockData.categories[index].icon),
                    trailing: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        // handle add to cart action
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
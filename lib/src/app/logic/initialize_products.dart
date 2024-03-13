import 'package:flutter_sqlite/core/utils/logger.dart';
import 'package:sqflite/sqflite.dart' as sql;

class InitializeProducts {
  const InitializeProducts._();

  static Future<void> initializeProducts(sql.Database db) async {
    // Check if the Products table is empty
    try {
      final count = sql.Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Products'),
      );
      if (count == 0) {
        for (final product in sampleProducts) {
          try {
            await db.insert(
              'Products',
              product,
              conflictAlgorithm: sql.ConflictAlgorithm.replace,
            );
          } catch (e, stackTrace) {
            logger.error(e.toString(), stackTrace: stackTrace);
          }
        }
      }
    } catch (e, stackTrace) {
      logger.error(e.toString(), stackTrace: stackTrace);
    }
  }
}

List<Map<String, dynamic>> sampleProducts = [
  {
    'name': 'Spaghetti Carbonara',
    'description': 'Classic Italian pasta with eggs, cheese, pancetta, and black pepper',
    'price': 11.99,
    'category': 'Main Course',
    'availability': 1,
    'imageUrl':
        'https://static01.nyt.com/images/2021/02/14/dining/carbonara-horizontal/carbonara-horizontal-square640-v2.jpg',
    'rating': 4.7,
    'preparationTime': 20, // minutes
    'createdAt': DateTime.now().toUtc().toString(),
    'updatedAt': DateTime.now().toUtc().toString(),
  },
  {
    'name': 'Margherita Pizza',
    'description': 'Classic pizza with tomato sauce, mozzarella, and basil',
    'price': 9.99,
    'category': 'Main Course',
    'availability': 1,
    'imageUrl': 'https://cookieandkate.com/images/2021/07/classic-margherita-pizza.jpg',
    'rating': 4.5,
    'preparationTime': 15, // minutes
    'createdAt': DateTime.now().toUtc().toString(),
    'updatedAt': DateTime.now().toUtc().toString(),
  },
  {
    'name': 'Caesar Salad',
    'description': 'Romaine lettuce, croutons, parmesan cheese, and Caesar dressing',
    'price': 7.99,
    'category': 'Appetizer',
    'availability': 1,
    'imageUrl':
        'https://cdn.loveandlemons.com/wp-content/uploads/2019/12/easy-appetizers-1-500x500.jpg',
    'rating': 4.2,
    'preparationTime': 10, // minutes
    'createdAt': DateTime.now().toUtc().toString(),
    'updatedAt': DateTime.now().toUtc().toString(),
  },
  {
    'name': 'Chocolate Lava Cake',
    'description': 'Warm chocolate cake with a flowing chocolate center',
    'price': 6.50,
    'category': 'Dessert',
    'availability': 1,
    'imageUrl':
        'https://preppykitchen.com/wp-content/uploads/2022/03/Chocolate-Lava-Cake-Recipe.jpg',
    'rating': 4.8,
    'preparationTime': 20, // minutes
    'createdAt': DateTime.now().toUtc().toString(),
    'updatedAt': DateTime.now().toUtc().toString(),
  },
  {
    'name': 'Grilled Salmon',
    'description': 'Grilled salmon fillet with a lemon butter sauce',
    'price': 15.99,
    'category': 'Main Course',
    'availability': 1,
    'imageUrl': 'https://www.acouplecooks.com/wp-content/uploads/2020/05/Grilled-Salmon-015-1.jpg',
    'rating': 4.6,
    'preparationTime': 25, // minutes
    'createdAt': DateTime.now().toUtc().toString(),
    'updatedAt': DateTime.now().toUtc().toString(),
  },
  {
    'name': 'Pepsi',
    'description': 'Refreshing cola-flavored soft drink',
    'price': 1.99,
    'category': 'Drinks',
    'availability': 1,
    'imageUrl': 'https://dayako15.kz/wp-content/uploads/2020/11/37-450x450.jpg',
    'rating': 4.3,
    'preparationTime': 0, // minutes, assuming no preparation time
    'createdAt': DateTime.now().toUtc().toString(),
    'updatedAt': DateTime.now().toUtc().toString(),
    'amount': 330,
  },
  {
    'name': 'Tiramisu',
    'description':
        'Coffee-flavored Italian dessert made with ladyfingers, mascarpone, cocoa, and espresso',
    'price': 8.50,
    'category': 'Dessert',
    'availability': 1,
    'imageUrl':
        'https://handletheheat.com/wp-content/uploads/2023/12/best-tiramisu-recipe-SQUARE.jpg',
    'rating': 4.9,
    'preparationTime': 30, // minutes
    'createdAt': DateTime.now().toUtc().toString(),
    'updatedAt': DateTime.now().toUtc().toString(),
  },
  {
    'name': 'Garlic Bread',
    'description': 'Crusty bread slathered with garlic butter and toasted',
    'price': 4.99,
    'category': 'Appetizer',
    'availability': 1,
    'imageUrl': 'https://www.budgetbytes.com/wp-content/uploads/2023/08/Garlic-Bread-close.jpg',
    'rating': 4.5,
    'preparationTime': 10, // minutes
    'createdAt': DateTime.now().toUtc().toString(),
    'updatedAt': DateTime.now().toUtc().toString(),
  },
  {
    'name': 'Lemon Mint Mojito',
    'description': 'Fresh mint leaves muddled with sugar and lemon juice, topped with soda',
    'price': 5.99,
    'category': 'Drink',
    'availability': 1,
    'imageUrl':
        'https://shop.mapro.com/admin_panel/site_data/uploads/product_images/big/53453b3eb998fbe9c568079907ed3e3e.jpg',
    'rating': 4.6,
    'preparationTime': 0, // minutes
    'createdAt': DateTime.now().toUtc().toString(),
    'updatedAt': DateTime.now().toUtc().toString(),
    'amount': 0, // milliliters
  }
];

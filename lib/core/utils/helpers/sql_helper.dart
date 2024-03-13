import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  const SQLHelper._();

  /// Create the products table.
  static Future<void> createProductsTable(sql.Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS Products (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT NOT NULL,
      description TEXT,
      price REAL NOT NULL,
      category TEXT,
      availability INTEGER NOT NULL, 
      imageUrl TEXT,
      rating REAL,
      preparationTime INTEGER,
      amount INTEGER,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
    ) 
  ''');
  }

  static Future<void> createOrdersTable(sql.Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS Orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      priceAtOrder REAL NOT NULL,
      quantity INTEGER NOT NULL,  
      productId INTEGER NOT NULL,
      productName TEXT NOT NULL,
      productPrice REAL NOT NULL,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
      FOREIGN KEY (productId) REFERENCES Products(id)
    )
  ''');
  }
}

import 'package:flutter_sqlite/src/products/model/product_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

abstract interface class ProductDataSource {
  /// Get the list of products
  Future<List<Product>> getProducts();
}

final class ProductDataSourceImpl implements ProductDataSource {
  const ProductDataSourceImpl({
    required sql.Database db,
  }) : _db = db;

  final sql.Database _db;

  // Get the list of products
  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await _db.query('Products');

      return products.map(Product.fromJson).toList();
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(e, stackTrace);
    }
  }
}

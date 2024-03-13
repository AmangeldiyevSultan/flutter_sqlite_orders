import 'package:flutter_sqlite/src/products/data/product_data_source.dart';
import 'package:flutter_sqlite/src/products/model/product_model.dart';

abstract interface class ProductRepository {
  /// Get the list of products
  Future<List<Product>> getProducts();
}

final class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._dataSource);

  final ProductDataSource _dataSource;

  @override
  Future<List<Product>> getProducts() => _dataSource.getProducts();
}

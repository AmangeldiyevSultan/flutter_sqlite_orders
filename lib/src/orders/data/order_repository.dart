import 'package:flutter_sqlite/src/orders/data/order_data_source.dart';
import 'package:flutter_sqlite/src/orders/model/order_model.dart';

abstract interface class OrderRepository {
  /// Get the list of products
  Future<List<Order>> getOrders();

  /// Add an order
  Future<int> addOrder(Order order);

  /// Update an order
  Future<void> updateOrder(Order order);

  /// Delete an order
  Future<void> deleteOrder(int orderId);
}

final class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this._dataSource);

  final OrderDataSource _dataSource;

  @override
  Future<List<Order>> getOrders() => _dataSource.getOrders();

  @override
  Future<int> addOrder(Order order) => _dataSource.addOrder(order);

  @override
  Future<void> updateOrder(Order order) => _dataSource.updateOrder(order);

  @override
  Future<void> deleteOrder(int orderId) => _dataSource.deleteOrder(orderId);
}

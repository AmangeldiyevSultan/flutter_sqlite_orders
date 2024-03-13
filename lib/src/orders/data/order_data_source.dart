import 'package:flutter_sqlite/src/orders/model/order_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

abstract interface class OrderDataSource {
  /// Get the list of orders
  Future<List<Order>> getOrders();

  /// Add an order
  Future<int> addOrder(Order order);

  /// Update an order
  Future<void> updateOrder(Order order);

  /// Delete an order
  Future<void> deleteOrder(int orderId);
}

final class OrderDataSourceImpl implements OrderDataSource {
  const OrderDataSourceImpl({
    required sql.Database db,
  }) : _db = db;

  final sql.Database _db;

  // Get the list of products
  @override
  Future<List<Order>> getOrders() async {
    final orders = await _db.query('Orders');

    return orders.map(Order.fromJson).toList();
  }

  // Add an order
  @override
  Future<int> addOrder(Order order) async {
    final orderId = await _db.insert(
      'Orders',
      order.toJson(),
    );
    return orderId;
  }

  // Update an order
  @override
  Future<void> updateOrder(Order order) async {
    await _db.update(
      'Orders',
      order.toJson(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  @override
  Future<void> deleteOrder(int orderId) {
    return _db.delete(
      'Orders',
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}

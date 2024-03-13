import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@Freezed()
class Order with _$Order {
  const factory Order({
    required int productId,
    required double priceAtOrder,
    required int quantity,
    required String productName,
    required double productPrice,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? id,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

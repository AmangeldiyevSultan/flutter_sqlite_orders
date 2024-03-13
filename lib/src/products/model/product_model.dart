import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@Freezed()
class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    required String description,
    required double price,
    required String category,
    required int availability,
    required String imageUrl,
    required double rating,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? preparationTime,
    int? amount,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

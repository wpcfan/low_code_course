import 'package:equatable/equatable.dart';

import 'block_data.dart';

class Product extends Equatable implements BlockData {
  final int? id;
  final String? sku;
  final String? name;
  final String? description;
  final List<String> images;
  final String? price;
  final String? originalPrice;

  const Product({
    this.id,
    this.sku,
    this.name,
    this.description,
    this.images = const [],
    this.price,
    this.originalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      price: json['price'] as String?,
      originalPrice: json['originalPrice'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'description': description,
      'images': images,
      'price': price,
      'originalPrice': originalPrice,
    };
  }

  @override
  List<Object?> get props => [
        id,
        sku,
        name,
        description,
        images,
        price,
        originalPrice,
      ];

  @override
  String toString() {
    return 'Product{id: $id, sku: $sku, name: $name, description: $description, images: $images, price: $price, originalPrice: $originalPrice}';
  }

  Product copyWith({
    int? id,
    String? sku,
    String? name,
    String? description,
    List<String>? images,
    String? price,
    String? originalPrice,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
    );
  }
}

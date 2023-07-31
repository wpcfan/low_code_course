import 'block_data.dart';

class Product implements BlockData {
  final int? id;
  final String? sku;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? price;
  final String? originalPrice;

  const Product({
    this.id,
    this.sku,
    this.name,
    this.description,
    this.imageUrl,
    this.price,
    this.originalPrice,
  });

  @override
  List<Object?> get props => [
        id,
        sku,
        name,
        description,
        imageUrl,
        price,
        originalPrice,
      ];

  @override
  String toString() {
    return 'Product{id: $id, sku: $sku, name: $name, description: $description, imageUrl: $imageUrl, price: $price, originalPrice: $originalPrice}';
  }

  @override
  bool? get stringify => true;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      price: json['price'] as String?,
      originalPrice: json['originalPrice'] as String?,
    );
  }
}

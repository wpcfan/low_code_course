import 'block_data.dart';
import 'my_link.dart';

class ImageData implements BlockData {
  final String image;
  final MyLink link;

  const ImageData({
    required this.image,
    required this.link,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      image: json['image'] as String,
      link: MyLink.fromJson(json['link'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'link': link.toJson(),
    };
  }

  @override
  String toString() {
    return 'ImageData{image: $image, link: $link}';
  }

  ImageData copyWith({
    String? image,
    MyLink? link,
  }) {
    return ImageData(
      image: image ?? this.image,
      link: link ?? this.link,
    );
  }
}

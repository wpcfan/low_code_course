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
}

import 'block_data.dart';
import 'my_link.dart';

class ImageData implements BlockData {
  final String imageUrl;
  final MyLink link;

  const ImageData({
    required this.imageUrl,
    required this.link,
  });

  @override
  List<Object?> get props => [imageUrl, link];

  @override
  String toString() {
    return 'ImageData{imageUrl: $imageUrl, link: $link}';
  }

  @override
  bool? get stringify => true;

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      imageUrl: json['imageUrl'] as String,
      link: MyLink.fromJson(json['link'] as Map<String, dynamic>),
    );
  }
}

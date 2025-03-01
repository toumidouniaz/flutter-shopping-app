import 'package:shopping_card/models/item.dart';

class Categories {
  final String id;
  String marketId;
  String name;
  List<Item> items;
  final String imgurl;

  Categories({
    required this.id,
    required this.marketId,
    required this.name,
    this.items = const [],
    this.imgurl = 'images/app_bg3.jpg',
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marketId': marketId,
      'name': name,
      'imgurl': imgurl,
    };
  }

  // Convert from Map (for loading from database)
  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'],
      marketId: map['marketId'],
      name: map['name'],
      imgurl: map['imgurl'],
    );
  }
}

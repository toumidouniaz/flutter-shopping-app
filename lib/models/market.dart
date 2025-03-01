import 'dart:convert';

import 'package:shopping_card/models/category.dart';

class Market {
  final String id;
  final String name;
  final String comment;
  List<Categories> categories;
  final List<String> categoryIds;

  Market({
    required this.id,
    required this.name,
    required this.comment,
    this.categories = const [],
    this.categoryIds = const [],
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'comment': comment,
      'categoryIds': jsonEncode(categoryIds)
    };
  }

  // Convert from Map (for loading from database)
  factory Market.fromMap(Map<String, dynamic> map) {
    return Market(
        id: map['id'],
        name: map['name'],
        comment: map['comment'],
        categoryIds: List<String>.from(jsonDecode(map['categoryIds'])));
  }
}

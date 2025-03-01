class Item {
  final String id;
  final String categoryId;
  final String name;
  int quantity;
  double price;
  final String notes;
  bool isImportant;
  String? photoPath;

  Item({
    required this.id,
    required this.categoryId,
    required this.name,
    this.quantity = 1,
    this.price = 0.0,
    this.notes = '',
    this.isImportant = false,
    this.photoPath,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'notes': notes,
      'isImportant': isImportant ? 1 : 0,
      'photoPath': photoPath,
    };
  }

  // Convert from Map (for loading from database)
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        id: map['id'],
        categoryId: map['categoryId'],
        name: map['name'],
        quantity: map['quantity'],
        price: map['price'],
        notes: map['notes'],
        isImportant: map['isImportant'] == 1,
        photoPath: map['photoPath']);
  }
}

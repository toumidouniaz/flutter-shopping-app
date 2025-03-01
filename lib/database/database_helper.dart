import 'dart:io';
import 'package:flutter/foundation.dart'; // For platform check
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../models/profile.dart';
import '../models/market.dart';
import '../models/category.dart';
import '../models/item.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  late Database _database;
  late Box profileBox;
  late Box marketBox;
  late Box categoryBox;
  late Box itemBox;

  // Initialize the database depending on the platform (web or mobile)
  Future<void> init() async {
    if (kIsWeb) {
      // Initialize Hive for Web
      await Hive.initFlutter();
      profileBox = await Hive.openBox('profile');
      marketBox = await Hive.openBox('markets');
      categoryBox = await Hive.openBox('categories');
      itemBox = await Hive.openBox('items');
    } else {
      // Initialize SQLite for Mobile
      Directory documentsDir = await getApplicationDocumentsDirectory();
      String path = join(documentsDir.path, 'app.db');
      _database = await openDatabase(path,
          version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Add the new column 'categoryIds' to the market table (if not already added)
      await db.execute('ALTER TABLE market ADD COLUMN categoryIds TEXT');
    }
    if (oldVersion < 4) {
      // Add the 'isImportant' column to the item table (if not already added)
      await db
          .execute('ALTER TABLE item ADD COLUMN isImportant INTEGER DEFAULT 0');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT,
        avatarPath TEXT
      )
    ''');

    // Market Table (SQLite)
    await db.execute('''
      CREATE TABLE market (
        id TEXT PRIMARY KEY,
        name TEXT,
        comment TEXT,
        categoryIds TEXT
      )
    ''');

    // Categories Table (SQLite)
    await db.execute('''
      CREATE TABLE category (
        id TEXT PRIMARY KEY,
        marketId TEXT,
        name TEXT,
        imgurl TEXT
      )
    ''');

    // Item Table (SQLite)
    await db.execute('''
      CREATE TABLE item (
        id TEXT PRIMARY KEY,
        categoryId TEXT,
        name TEXT,
        quantity INTEGER,
        price REAL,
        notes TEXT,
        isImportant INTEGER DEFAULT 0, 
        photoPath TEXT
      )
    ''');
  }

  // Save Profile
  Future<void> saveProfile(Profile profile) async {
    if (kIsWeb) {
      await profileBox.put('profile', profile.toMap());
    } else {
      await _database.insert('profile', profile.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Load Profile
  Future<Profile?> loadProfile() async {
    if (kIsWeb) {
      var data = profileBox.get('profile');
      return data != null
          ? Profile.fromMap(Map<String, dynamic>.from(data))
          : null;
    } else {
      List<Map<String, dynamic>> result = await _database.query('profile');
      if (result.isNotEmpty) {
        return Profile.fromMap(result.first);
      }
      return null;
    }
  }

  Future<bool> isUserExists() async {
    final result = await _database
        .query('profile'); // Replace 'users' with your table name
    return result.isNotEmpty;
  }

  // Load all markets
  Future<List<Market>> loadAllMarkets() async {
    if (kIsWeb) {
      return marketBox.values
          .map((data) => Market.fromMap(Map<String, dynamic>.from(data)))
          .toList();
    } else {
      List<Map<String, dynamic>> result = await _database.query('market');
      return result.map((map) => Market.fromMap(map)).toList();
    }
  }

  // Save Market
  Future<void> saveMarket(Market market) async {
    if (kIsWeb) {
      await marketBox.put(market.id, market.toMap());
    } else {
      await _database.insert('market', market.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Load Market by ID
  Future<Market?> loadMarket(String marketId) async {
    if (kIsWeb) {
      // For web, you may want to handle it differently (for now, assume simple fetching or loading from a custom storage)
      return null;
    } else {
      List<Map<String, dynamic>> result = await _database.query(
        'market',
        where: 'id = ?',
        whereArgs: [marketId],
      );
      if (result.isNotEmpty) {
        return Market.fromMap(result.first);
      }
      return null;
    }
  }

  // Load categories for a market
  Future<List<Categories>> loadCategories(String marketId) async {
    if (kIsWeb) {
      return categoryBox.values
          .where((data) => data['marketId'] == marketId)
          .map((data) => Categories.fromMap(Map<String, dynamic>.from(data)))
          .toList();
    } else {
      List<Map<String, dynamic>> result = await _database.query(
        'category',
        where: 'marketId = ?',
        whereArgs: [marketId],
      );
      return result.map((data) => Categories.fromMap(data)).toList();
    }
  }

  Future<void> saveCategory(Categories category) async {
    if (kIsWeb) {
      await categoryBox.put(category.id, category.toMap());
    } else {
      await _database.insert('category', category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Save Item
  Future<void> saveItem(Item item) async {
    if (kIsWeb) {
      await itemBox.put(item.id, item.toMap());
    } else {
      await _database.insert('item', item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Load items for a category
  Future<List<Item>> loadItems(String categoryId) async {
    if (kIsWeb) {
      // For web (Hive storage)
      final matchingValues =
          itemBox.values.where((data) => data['categoryId'] == categoryId);

      return matchingValues.isNotEmpty
          ? matchingValues
              .map((data) => Item.fromMap(Map<String, dynamic>.from(data)))
              .toList()
          : [];
    } else {
      // For non-web (SQLite)
      List<Map<String, dynamic>> result = await _database.query(
        'item',
        where: 'categoryId = ?',
        whereArgs: [categoryId],
      );

      return result.isNotEmpty
          ? result.map((data) => Item.fromMap(data)).toList()
          : [];
    }
  }

  // Helper to delete a market

  Future<void> deleteMarket(String marketId) async {
    if (kIsWeb) {
      // Delete the market itself
      await marketBox.delete(marketId);

      // Delete all associated categories
      final categoriesToDelete = categoryBox.values
          .where((data) => data['marketId'] == marketId)
          .toList();
      for (var category in categoriesToDelete) {
        String categoryId = category['id'];
        await categoryBox.delete(categoryId);

        // Delete all associated items of each category
        final itemsToDelete = itemBox.values
            .where((data) => data['categoryId'] == categoryId)
            .toList();
        for (var item in itemsToDelete) {
          await itemBox.delete(item['id']);
        }
      }
    } else {
      // SQLite logic (already implemented)
      await _database.delete('market', where: 'id = ?', whereArgs: [marketId]);
      await _database
          .delete('category', where: 'marketId = ?', whereArgs: [marketId]);
    }
  }

  // Helper to delete a category
  Future<void> deleteCategories(String categoryId) async {
    if (kIsWeb) {
      await categoryBox.delete(categoryId); // Delete the category itself
      // Remove associated items in the category
      final itemsToDelete = itemBox.values
          .where((item) => item['categoryId'] == categoryId)
          .toList();
      for (var item in itemsToDelete) {
        await itemBox.delete(item['id']);
      }
    } else {
      await _database
          .delete('category', where: 'id = ?', whereArgs: [categoryId]);
      // Also delete associated items
      await _database
          .delete('item', where: 'categoryId = ?', whereArgs: [categoryId]);
    }
  }

  // Helper to delete an item
  Future<void> deleteItem(String itemId) async {
    if (kIsWeb) {
      // For web, implement custom delete logic for Hive
    } else {
      await _database.delete('item', where: 'id = ?', whereArgs: [itemId]);
    }
  }

  Future<void> deleteAllCategories(String marketId) async {
    if (kIsWeb) {
      // Delete categories associated with the market in Hive
      final categoriesToDelete = categoryBox.values
          .where((data) => data['marketId'] == marketId)
          .toList();
      for (var category in categoriesToDelete) {
        await categoryBox.delete(category['id']); // Delete each category
      }
    } else {
      // Delete categories associated with the market in SQLite
      await _database.delete(
        'category',
        where: 'marketId = ?',
        whereArgs: [marketId],
      );
      // Optionally, delete associated items if needed
      await _database.delete(
        'item',
        where: 'categoryId IN (SELECT id FROM category WHERE marketId = ?)',
        whereArgs: [marketId],
      );
    }
  }

  Future<void> updateCategory(Categories category) async {
    if (kIsWeb) {
      await categoryBox.put(
          category.id, category.toMap()); // Overwrite the category in Hive
    } else {
      await _database.update(
        'category',
        category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
    }
  }

  Future<void> updateItem(Item item) async {
    if (kIsWeb) {
      await itemBox.put(item.id, item.toMap()); // Overwrite the item in Hive
    } else {
      await _database.update(
        'item',
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      );
    }
  }

  // Fetch all items
  Future<List<Item>> getItems(String marketId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'item',
      where: 'marketId = ?',
      whereArgs: [marketId],
    );

    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  // Update the importance status
  Future<void> updateItemImportance(String itemId, bool isImportant) async {
    await _database.update(
      'item',
      {'isImportant': isImportant ? 1 : 0}, // Update only the importance status
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  Future<List<Item>> getFavoriteItems() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('item', where: 'isImportant = ?', whereArgs: [1]);
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }
}

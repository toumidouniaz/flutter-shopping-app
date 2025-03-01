import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopping_card/database/database_helper.dart';
import 'package:shopping_card/market_screens/items_screen.dart';
import 'package:shopping_card/models/category.dart';
import 'package:shopping_card/models/market.dart';
import 'package:shopping_card/models/profilemanager.dart';
import 'package:shopping_card/style/colors.dart';
import 'package:shopping_card/style/decoration.dart';
import 'package:shopping_card/style/textstyle.dart';

class CategoriesScreen extends StatefulWidget {
  final Market currentmarket;

  const CategoriesScreen({super.key, required this.currentmarket});

  @override
  State<CategoriesScreen> createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  final UpperBarMainScreen upperBarMainScreen = UpperBarMainScreen();
  dynamic bgImg = const AssetImage('images/market1_bg.jpg');
  String? userName;
  String? avatarPath;
  List<Categories> category = [];

  Future<void> _loadUserProfile() async {
    final profile = await ProfileManager.loadProfile();
    setState(() {
      userName = profile?.userName;
      avatarPath = profile?.avatarPath;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadcategories();
  }

  Future<void> _loadcategories() async {
    List<Categories> loadedCategories =
        await DatabaseHelper().loadCategories(widget.currentmarket.id);
    setState(() {
      category = loadedCategories;
      widget.currentmarket.categories = loadedCategories;
    });
  }

  ButtonStyle elevatedButtonStyle(Size size) {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(177, 204, 173, 152),
      fixedSize: size,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: aubergine, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: upperBarMainScreen.getAppBar(context, "Categories"),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: bgImg, fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 5),
              if (avatarPath != null && userName != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: aubergine,
                      radius: 27,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(avatarPath!),
                        radius: 25,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Text(userName!, style: name),
                  ],
                )
              else
                const CircularProgressIndicator(),
              const SizedBox(height: 5),
              Text(
                "List of Categories in ${widget.currentmarket.name}",
                style: description,
                textAlign: TextAlign.center,
              ),
              Expanded(child: categorieslist()),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => _showNewCategoryDialog(),
                      style: elevatedButtonStyle(
                        Size(MediaQuery.of(context).size.width / 2.5,
                            MediaQuery.of(context).size.height / 10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 8,
                            width: 8,
                            child: Image.asset('images/icons/plus_cl.png'),
                          ),
                          const SizedBox(width: 2),
                          Text("New Category", style: semibolditalicobrg),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final confirmDeleteAll = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "Delete All Categories",
                              style: elevatedbuttonstyle2,
                            ),
                            content: Text(
                              "Are you sure you want to delete all categories in this market?",
                              style: semibolditalicobrg,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("Cancel",
                                    style: semibolditalicobrgBig),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await DatabaseHelper().deleteAllCategories(
                                      widget.currentmarket.id);
                                  await _loadcategories();
                                  Navigator.of(context).pop(true);
                                },
                                child: Text("Delete All",
                                    style: elevatedbuttonstyle2),
                              ),
                            ],
                          ),
                        );
                      },
                      style: elevatedButtonStyle(
                        Size(MediaQuery.of(context).size.width / 2.5,
                            MediaQuery.of(context).size.height / 10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 8,
                            width: 8,
                            child: Image.asset('images/icons/cross.png'),
                          ),
                          const SizedBox(width: 3),
                          Text("Delete List", style: semibolditalicobrg),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categorieslist() {
    return ListView.builder(
      itemCount: category.length,
      itemBuilder: (context, i) {
        final currentCategory = category[i];
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ItemsScreen(currentcategory: currentCategory);
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: rosewood,
                  fixedSize: Size(MediaQuery.of(context).size.width / 2,
                      MediaQuery.of(context).size.height / 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: aubergine, width: 3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(currentCategory.name, style: semibolditalic),
                ),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: IconButton(
                  onPressed: () {
                    final TextEditingController nameController =
                        TextEditingController(text: currentCategory.name);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: rosewood,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text("Edit Category", style: semibolditalic),
                        content: TextField(
                          controller: nameController,
                          style: semibolditalicsmall,
                          decoration: InputDecoration(
                            hintText: "Enter new category name",
                            hintStyle: hint,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Cancel", style: semibolditalic),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (nameController.text.trim().isNotEmpty) {
                                currentCategory.name = nameController.text;
                                await DatabaseHelper()
                                    .updateCategory(currentCategory);
                                await _loadcategories();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("Save", style: semibolditalic),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Image.asset('images/icons/edit.png'),
                ),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: IconButton(
                  onPressed: () async {
                    final confirmDelete = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Delete Category",
                            style: elevatedbuttonstyle2),
                        content: Text(
                            "Are you sure you want to delete this category?",
                            style: semibolditalicobrg),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("Cancel", style: semibolditalicobrgBig),
                          ),
                          TextButton(
                            onPressed: () async {
                              await DatabaseHelper()
                                  .deleteCategories(currentCategory.id);
                              await _loadcategories();
                              Navigator.of(context).pop(true);
                            },
                            child: Text("Delete", style: elevatedbuttonstyle2),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Image.asset('images/icons/trash_cl.png'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNewCategoryDialog() {
    final TextEditingController nameController = TextEditingController();
    Categories? selectedPresetCategory;

    var presetCategories = [
      Categories(
        id: _generateUniqueId(),
        marketId: "",
        name: "Diary",
        imgurl: "images/diary_bg.jpg",
      ),
      Categories(
        id: _generateUniqueId(),
        marketId: "",
        name: "Vegetables",
        imgurl: "images/vegies_bg.jpg",
      ),
      Categories(
        id: _generateUniqueId(),
        marketId: "",
        name: "Meat",
        imgurl: "images/meat_bg.jpg",
      ),
      Categories(
        id: _generateUniqueId(),
        marketId: "",
        name: "Fruits",
        imgurl: "images/fruits_bg.jpg",
      ),
      Categories(
        id: _generateUniqueId(),
        marketId: "",
        name: "Bakery",
        imgurl: "images/sweets1.jpg",
      ),
      Categories(
        id: _generateUniqueId(),
        marketId: "",
        name: "Stationary",
        imgurl: "images/bg_op5.jpg",
      ),
      Categories(
        id: _generateUniqueId(),
        marketId: "",
        name: "Toiletries",
        imgurl: "images/bg_op4.jpg",
      ),
      Categories(
        id: _generateUniqueId(),
        marketId: "",
        name: "Party",
        imgurl: "images/bg_op6.jpg",
      ),
      Categories(
        id: _generateUniqueId(),
        marketId: "",
        name: "Decoration",
        imgurl: "images/bg_op7.jpg",
      ),
      Categories(
        id: _generateUniqueId(),
        marketId: "",
        name: "Fashion",
        imgurl: "images/fashion.jpeg",
      ),
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: rosewood,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("New Category", style: semibolditalic),
              const SizedBox(height: 15),
              TextField(
                controller: nameController,
                style: semibolditalicsmall,
                decoration: InputDecoration(
                  hintText: "Enter category name",
                  hintStyle: hint,
                ),
              ),
              const SizedBox(height: 15),
              Text("Or select a preset category:", style: semibolditalic),
              const SizedBox(height: 10),
              // List of preset categories
              Expanded(
                child: ListView.builder(
                  itemCount: presetCategories.length,
                  itemBuilder: (context, index) {
                    final category = presetCategories[index];
                    return ListTile(
                      title: Text(category.name, style: list),
                      leading:
                          Image.asset(category.imgurl, width: 40, height: 40),
                      selected: selectedPresetCategory == category,
                      selectedTileColor: aubergine.withOpacity(0.2),
                      onTap: () {
                        setState(() {
                          selectedPresetCategory = category;
                          nameController.text = category.name;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancel", style: semibolditalic),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (nameController.text.trim().isNotEmpty) {
                        Categories newCategory = Categories(
                          marketId: widget.currentmarket.id,
                          id: _generateUniqueId(),
                          name: nameController.text,
                          imgurl: selectedPresetCategory?.imgurl ??
                              "images/app_bg3.jpg",
                        );
                        await DatabaseHelper().saveCategory(newCategory);
                        await _loadcategories();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Save", style: semibolditalic),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _generateUniqueId() {
    final random = Random();
    return '${DateTime.now().millisecondsSinceEpoch}-${random.nextInt(10000)}';
  }
}

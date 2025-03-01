import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shopping_card/database/database_helper.dart';
import 'package:shopping_card/main_screens/view_screen.dart';
import 'package:shopping_card/models/category.dart';
import 'package:shopping_card/models/market.dart';
import 'package:shopping_card/models/profilemanager.dart';
import 'package:shopping_card/style/colors.dart';
import 'package:shopping_card/style/decoration.dart';
import 'package:shopping_card/style/textstyle.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  final UpperBarMainScreen upperBarMainScreen = UpperBarMainScreen();
  late TextEditingController marketnameController;
  late TextEditingController marketcommentController;
  late List<Categories> presetCategories; // Late initialization
  Map<String, bool> addedCategories = {}; // Track added categories by their IDs
  String? userName;
  String? avatarPath;

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
    marketnameController = TextEditingController();
    marketcommentController = TextEditingController();

    presetCategories = [
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
    ];

    for (var category in presetCategories) {
      addedCategories[category.id] = false;
    }
  }

  @override
  void dispose() {
    marketnameController.dispose();
    marketcommentController.dispose();
    super.dispose();
  }

  String _generateUniqueId() {
    final random = Random();
    return '${DateTime.now().millisecondsSinceEpoch}-${random.nextInt(10000)}';
  }

  Future<void> _addCategory(Categories category) async {
    setState(() {
      addedCategories[category.id] = true;
    });

    await DatabaseHelper().saveCategory(category);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${category.name} added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: upperBarMainScreen.getAppBar(context, "Create List"),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(image: bgimg, fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              const SizedBox(height: 10),
              Text(
                "Create a new Market List",
                style: description,
                textAlign: TextAlign.center,
              ),
              Tooltip(
                message: "Enter the name of the market",
                textStyle: hint,
                decoration: BoxDecoration(
                  border: Border.all(color: aubergine, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                  color: satinlin,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: TextField(
                    controller: marketnameController,
                    style: semibolditalicsmall,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: rosewood,
                      hintText: "Market name",
                      hintStyle: semibolditalictransparent,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: aubergine, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: aubergine, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width / 2.5,
                child: TextField(
                  controller: marketcommentController,
                  style: semibolditalicsmall,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: rosewood,
                    hintText: "Comment...",
                    hintStyle: semibolditalictransparent,
                    contentPadding: const EdgeInsets.only(
                      top: 40,
                      bottom: 40,
                      left: 10,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: aubergine, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: aubergine, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: presetCategories.map((category) {
                    return ListTile(
                      title: Text(category.name, style: list),
                      trailing: IconButton(
                        icon: Icon(
                          addedCategories[category.id] == true
                              ? Icons.check
                              : Icons.add,
                          color: aubergine,
                        ),
                        onPressed: () {
                          if (!addedCategories[category.id]!) {
                            _addCategory(category);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: _saveMarket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: rosewood,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width / 3,
                    MediaQuery.of(context).size.height / 12,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: aubergine, width: 3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text("Create", style: elevatedbuttonstyle1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveMarket() async {
    List<Categories> selectedCategoryList = presetCategories
        .where((category) => addedCategories[category.id] == true)
        .toList();

    List<String> categoryIds =
        selectedCategoryList.map((cat) => cat.id).toList();

    Market market = Market(
      id: _generateUniqueId(),
      name: marketnameController.text,
      comment: marketcommentController.text,
      categoryIds: categoryIds,
    );

    await DatabaseHelper().saveMarket(market);

    for (var category in selectedCategoryList) {
      category.marketId = market.id;
      await DatabaseHelper().saveCategory(category);
    }

    print(
        'Selected categories: ${selectedCategoryList.map((cat) => cat.name).toList()}');
    print('Category IDs: $categoryIds');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ViewScreen(newMarket: market),
      ),
    );
  }
}

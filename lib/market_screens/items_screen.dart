import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_card/database/database_helper.dart';
import 'package:shopping_card/models/category.dart';
import 'package:shopping_card/models/item.dart';
import 'package:shopping_card/models/profilemanager.dart';
import 'package:shopping_card/style/colors.dart';
import 'package:shopping_card/style/decoration.dart';
import 'package:shopping_card/style/textstyle.dart';

class ItemsScreen extends StatefulWidget {
  final Categories currentcategory;
  const ItemsScreen({required this.currentcategory, super.key});

  @override
  State<ItemsScreen> createState() => ItemsScreenState();
}

class ItemsScreenState extends State<ItemsScreen> {
  final UpperBarMainScreen upperBarMainScreen = UpperBarMainScreen();
  List<Item> items = [];
  final ImagePicker _picker = ImagePicker();
  late dynamic bgImg;
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
    // Initialize bgImg here
    bgImg = AssetImage(widget.currentcategory.imgurl);
    _loadUserProfile();
    _loadItems();
  }

  Future<void> _loadItems() async {
    if (kIsWeb) {
      // Example web handling logic (if you have Hive or local storage in use for web)
      List<Item> loadedItem =
          await DatabaseHelper().loadItems(widget.currentcategory.id);
      setState(() {
        items = loadedItem;
      });
    } else {
      // Load markets from SQLite for mobile/desktop
      List<Item> loadedItem =
          await DatabaseHelper().loadItems(widget.currentcategory.id);
      setState(() {
        items = loadedItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: upperBarMainScreen.getAppBar(context, "Items"),
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
        decoration: BoxDecoration(
            image: DecorationImage(image: bgImg, fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 5),
            Text(
              "These are all the items in your ${widget.currentcategory.name} list",
              style: description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Total: \$${calculateTotalExpenditure().toStringAsFixed(2)}',
              style: totalexpstyle,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: itemslist(),
            ),
            ElevatedButton(
              onPressed: () {
                _showEditDialog(context, title: "Add item");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(177, 204, 173, 152),
                elevation: 10,
                fixedSize: Size(MediaQuery.of(context).size.width / 8,
                    MediaQuery.of(context).size.height / 15),
              ),
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset('images/icons/plus_cl.png'),
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget itemslist() {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return Dismissible(
              key: Key(item.name),
              background: Container(
                color: rosewood,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('images/icons/trash.png'),
                ),
              ),
              secondaryBackground: Container(
                color: satinlin,
                alignment: Alignment.centerRight,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          'images/icons/edit.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('images/icons/camera.png',
                            fit: BoxFit.fitHeight),
                      ),
                    ]),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  final confirmDelete = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Delete Item", style: elevatedbuttonstyle2),
                      content: Text(
                          "Are you sure you want to delete this item?",
                          style: semibolditalicobrg),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("Cancel", style: semibolditalicobrgBig),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("Delete", style: elevatedbuttonstyle2),
                        ),
                      ],
                    ),
                  );

                  if (confirmDelete == true) {
                    await DatabaseHelper()
                        .deleteItem(item.id); // Delete from database
                    _loadItems(); // Reload the updated list from the database
                  }
                } else if (direction == DismissDirection.endToStart) {
                  _showEditOptions(context, i);
                }
                return false;
              },
              child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height / 8,
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: BoxDecoration(
                      color: solidpink,
                      border: Border(bottom: BorderSide(color: aubergine))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          item.isImportant
                              ? Icons.star
                              : Icons.star_border, // Filled or empty star
                          color: item.isImportant
                              ? Colors.yellow
                              : aubergine, // Change color
                        ),
                        onPressed: () async {
                          setState(() {
                            item.isImportant =
                                !item.isImportant; // Toggle importance
                          });
                          await DatabaseHelper()
                              .updateItemImportance(item.id, item.isImportant);
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            item.name,
                            style: itemstyle,
                          ),
                          Text(
                            item.notes,
                            style: comment,
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            final TextEditingController qtyController =
                                TextEditingController(
                                    text: item.quantity.toString());
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: rosewood,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: Text("Edit Quantity",
                                      style: semibolditalic),
                                  content: TextField(
                                    controller: qtyController,
                                    style: semibolditalicsmall,
                                    decoration: InputDecoration(
                                      hintText: "Enter ${item.name} quantity",
                                      hintStyle: hint,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child:
                                          Text("Cancel", style: semibolditalic),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          item.quantity =
                                              int.parse(qtyController.text);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child:
                                          Text("Save", style: semibolditalic),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll<Color>(pink),
                              shape: WidgetStatePropertyAll<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(color: aubergine)))),
                          child: Text(
                            'Qty: ${item.quantity}',
                            style: smalltxtwhite,
                          )),
                      TextButton(
                          onPressed: () {
                            final TextEditingController priController =
                                TextEditingController(
                                    text: item.price.toString());
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: rosewood,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title:
                                      Text("Edit Price", style: semibolditalic),
                                  content: TextField(
                                    controller: priController,
                                    decoration: InputDecoration(
                                      hintText: "Enter ${item.name} price",
                                      hintStyle: hint,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child:
                                          Text("Cancel", style: semibolditalic),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          item.price =
                                              double.parse(priController.text);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child:
                                          Text("Save", style: semibolditalic),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll<Color>(pink),
                              shape: WidgetStatePropertyAll<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(color: aubergine)))),
                          child: Text(
                            'Price: ${item.price}',
                            style: smalltxtwhite,
                          )),
                    ],
                  )));
        });
  }

  void _showEditOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset('images/icons/edit.png'),
              ),
              title: Text(
                "Edit Item",
                style: semibolditalicobrg,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showEditDialog(context, index: index, title: "Edit item");
              },
            ),
            ListTile(
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset('images/icons/camera.png'),
              ),
              title: Text(
                "Open Camera",
                style: semibolditalicobrg,
              ),
              onTap: () async {
                Navigator.of(context).pop();
                await _openCamera(index);
              },
            ),
            ListTile(
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset('images/icons/image.png'),
              ),
              title: Text(
                "Show picture",
                style: semibolditalicobrg,
              ),
              onTap: () {
                final currentItem = items[index];

                // First check if the path is not null or empty
                if (currentItem.photoPath != null &&
                    currentItem.photoPath!.isNotEmpty) {
                  // Then ensure the file actually exists on the device
                  if (File(currentItem.photoPath!).existsSync()) {
                    _showPictureDialog(context, currentItem.photoPath!);
                  } else {
                    // Handle cases where the file path is invalid
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'The image file is missing or was deleted.')),
                    );
                  }
                } else {
                  // No path stored in the item
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No picture available for this item.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context,
      {int? index, String title = "Edit Item"}) {
    final isEditing = index != null;
    final item = isEditing
        ? items[index]
        : Item(
            id: "00",
            name: "",
            quantity: 0,
            price: 0.0,
            notes: "",
            categoryId: widget.currentcategory.id);

    final nameController = TextEditingController(text: item.name);
    final quantityController =
        TextEditingController(text: item.quantity.toString());
    final priceController = TextEditingController(text: item.price.toString());
    final commentController = TextEditingController(text: item.notes ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: rosewood,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(title, style: semibolditalic),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: rosewood,
                    border:
                        Border(bottom: BorderSide(color: aubergine, width: 2))),
                child: TextField(
                  controller: nameController,
                  style: semibolditalicsmall,
                  decoration: InputDecoration(
                    hintText: "Enter new item name",
                    hintStyle: hint,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: rosewood,
                    border:
                        Border(bottom: BorderSide(color: aubergine, width: 2))),
                child: TextField(
                    controller: quantityController,
                    style: semibolditalicsmall,
                    decoration: InputDecoration(
                      hintText: "Enter the item quantity",
                      hintStyle: hint,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true)),
              ),
              Container(
                decoration: BoxDecoration(
                    color: rosewood,
                    border:
                        Border(bottom: BorderSide(color: aubergine, width: 2))),
                child: TextField(
                  controller: priceController,
                  style: semibolditalicsmall,
                  decoration: InputDecoration(
                    hintText: "Enter the item price",
                    hintStyle: hint,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: rosewood,
                    border:
                        Border(bottom: BorderSide(color: aubergine, width: 2))),
                child: TextField(
                  controller: commentController,
                  style: semibolditalicsmall,
                  decoration: InputDecoration(
                    hintText: "comment...",
                    hintStyle: hint,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: SizedBox(
                height: 20,
                width: 20,
                child: Image.asset('images/icons/cross.png'),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (isEditing) {
                  // Update item in the database
                  await DatabaseHelper().updateItem(Item(
                    id: item.id,
                    categoryId: widget.currentcategory.id,
                    name: nameController.text,
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    price: double.tryParse(priceController.text) ?? 0,
                    notes: commentController.text,
                  ));
                } else {
                  // Add new item to the database
                  await DatabaseHelper().saveItem(Item(
                    id: _generateUniqueId(),
                    categoryId: widget.currentcategory.id,
                    name: nameController.text,
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    price: double.tryParse(priceController.text) ?? 0,
                    notes: commentController.text,
                  ));
                }
                _loadItems(); // Reload items to update UI
                Navigator.of(context).pop();
              },
              child: Text("Save", style: semibolditalic),
            ),
          ],
        );
      },
    );
  }

  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> _openCamera(int currentIndex) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        final currentItem = items[currentIndex]; // Track current item index
        currentItem.photoPath = photo.path; // Save photo path to the item
      });

      // Update the item in the database with the photo path
      await DatabaseHelper().updateItem(items[currentIndex]);
      _loadItems(); // Reload the updated items list to reflect changes
    }
  }

  void _showPictureDialog(BuildContext context, String photoPath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(File(photoPath)), // Display image from file
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Close",
                    style: semibolditalicobrg,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double calculateTotalExpenditure() {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}

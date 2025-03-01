import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shopping_card/database/database_helper.dart';
import 'package:shopping_card/models/item.dart';
import 'package:shopping_card/style/colors.dart';
import 'package:shopping_card/style/decoration.dart';
import 'package:shopping_card/style/textstyle.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreen();
}

class _FavoritesScreen extends State<FavoritesScreen> {
  UpperBarMainScreen upperBarMainScreen = UpperBarMainScreen();
  late Future<List<Item>> favoriteItems;

  @override
  void initState() {
    super.initState();
    favoriteItems = DatabaseHelper().getFavoriteItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: upperBarMainScreen.getAppBar(context, "Favorites"),
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: bgimg, fit: BoxFit.fill),
        ),
        child: FutureBuilder<List<Item>>(
            future: favoriteItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text("There's no favorite items added yet",
                      style: semibolditalic),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];

                    return Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: solidpink,
                          border: Border(
                              bottom: BorderSide(color: aubergine, width: 1.5)),
                          borderRadius: BorderRadius.circular(3.0)),
                      child: ListTile(
                        leading: item.photoPath != null &&
                                item.photoPath!.isNotEmpty
                            ? _buildImage(item
                                .photoPath!) // Display the image if a valid path exists
                            : Icon(
                                Icons.image_rounded,
                                color: white,
                              ),
                        title: Text(
                          item.name,
                          style: itemstyle,
                          textAlign: TextAlign.center,
                        ),
                        titleAlignment: ListTileTitleAlignment.center,
                        horizontalTitleGap: 10.0,
                      ),
                    );
                  },
                );
              }
            }),
      )),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('/')) {
      // Assume it's a file path
      return Image.file(File(path), fit: BoxFit.cover, width: 50, height: 50);
    } else {
      // Assume it's an asset path
      return Image.asset(path, fit: BoxFit.cover, width: 50, height: 50);
    }
  }
}

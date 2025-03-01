import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_card/database/database_helper.dart';
import 'package:shopping_card/market_screens/categories.dart';
import 'package:shopping_card/models/market.dart';
import 'package:shopping_card/models/profilemanager.dart';
import 'package:shopping_card/style/colors.dart';
import 'package:shopping_card/style/decoration.dart';
import 'package:shopping_card/style/textstyle.dart';

class ViewScreen extends StatefulWidget {
  final Market? newMarket;
  const ViewScreen({super.key, this.newMarket});

  @override
  State<ViewScreen> createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {
  final UpperBarMainScreen upperBarMainScreen = UpperBarMainScreen();
  List<Market> markets = [];
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
    _loadMarkets(); // Load markets when the screen initializes
  }

  Future<void> _loadMarkets() async {
    if (kIsWeb) {
      // Example web handling logic (if you have Hive or local storage in use for web)
      List<Market> loadedMarkets = await DatabaseHelper().loadAllMarkets();
      setState(() {
        markets = loadedMarkets;
      });
    } else {
      // Load markets from SQLite for mobile/desktop
      List<Market> loadedMarkets = await DatabaseHelper().loadAllMarkets();
      setState(() {
        markets = loadedMarkets;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: upperBarMainScreen.getAppBar(context, "View List"),
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
              const SizedBox(height: 5),
              Text(
                "List of added Markets",
                style: description,
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: marketlist(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget marketlist() {
    return ListView.builder(
      itemCount: markets.length,
      itemBuilder: (context, i) {
        final market = markets[i];
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CategoriesScreen(
                      currentmarket: market,
                    );
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: rosewood,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width / 1.5,
                    MediaQuery.of(context).size.height / 8,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: aubergine, width: 3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      market.name,
                      style: semibolditalic,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      market.comment,
                      style: comment,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: IconButton(
                  onPressed: () {
                    _showEditMarketDialog(context, index: i, market: market);
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
                        title: Text(
                          "Delete Item",
                          style: elevatedbuttonstyle2,
                        ),
                        content: Text(
                          "Are you sure you want to delete this item?",
                          style: semibolditalicobrg,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              "Cancel",
                              style: semibolditalicobrgBig,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              "Delete",
                              style: elevatedbuttonstyle2,
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirmDelete == true) {
                      // Remove from database
                      await DatabaseHelper()
                          .deleteMarket(markets[i].id); // Delete market by ID

                      // Update the local list
                      setState(() {
                        markets.removeAt(i); // Remove from the local list
                      });
                    }
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

  void _showEditMarketDialog(BuildContext context,
      {int? index, Market? market}) {
    final TextEditingController nameController = TextEditingController(
      text: market?.name ?? "",
    );
    final TextEditingController commentController = TextEditingController(
      text: market?.comment ?? "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: rosewood,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            index == null ? "Add Market" : "Edit Market",
            style: semibolditalic,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: semibolditalicsmall,
                decoration: InputDecoration(
                  hintText: "Enter market name",
                  hintStyle: hint,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                style: semibolditalicsmall,
                decoration: InputDecoration(
                  hintText: "Enter market comment",
                  hintStyle: hint,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: semibolditalic),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (index == null) {
                    // Add new market
                    markets.add(Market(
                      id: _generateUniqueId(), // Generate unique ID
                      name: nameController.text,
                      comment: commentController.text,
                    ));
                  } else {
                    // Update existing market
                    markets[index] = Market(
                      id: market!.id, // Retain the existing ID
                      name: nameController.text,
                      comment: commentController.text,
                    );
                  }
                });
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
}

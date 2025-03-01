import 'package:flutter/material.dart';
import 'package:shopping_card/main_screens/create_screen.dart';
import 'package:shopping_card/main_screens/createprofile.dart';
import 'package:shopping_card/main_screens/view_screen.dart';
import 'package:shopping_card/models/profilemanager.dart';
import 'package:shopping_card/style/colors.dart';
import 'package:shopping_card/style/decoration.dart';
import 'package:shopping_card/style/textstyle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? username;
  String? avatarpath;
  UpperBarHomeScreen upperBarHomeScreen = UpperBarHomeScreen();

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Initiates profile loading when the screen initializes
  }

  Future<void> _loadUserProfile() async {
    final profile =
        await ProfileManager.loadProfile(); // Fetches data from the database
    setState(() {
      username = profile?.userName;
      avatarpath = profile?.avatarPath;
    });

    // If profile data is missing, navigate to the profile creation screen
    if (username == null || avatarpath == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreateProfile()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: upperBarHomeScreen.getAppBar(context),
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 1,
        decoration: BoxDecoration(
            image: DecorationImage(image: bgimg, fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to your Shopping List Tracker",
              style: description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            // Check if avatarPath and userName are loaded
            if (avatarpath != null && username != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: aubergine,
                    radius: 32,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(avatarpath!),
                      radius: 30,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Text(username!, style: name),
                ],
              )
            else
              const CircularProgressIndicator(),

            const SizedBox(height: 10),
            Tooltip(
              message: "Create a new list",
              textStyle: elevatedbuttonstyle2,
              decoration: BoxDecoration(
                  border: Border.all(color: aubergine, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                  color: satinlin),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const CreateScreen();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height / 10),
                      backgroundColor: rosewood,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Image.asset('images/icons/reminder.png'),
                      ),
                      Text(
                        'Create List',
                        style: elevatedbuttonstyle1,
                      )
                    ],
                  )),
            ),
            Tooltip(
              message: "View existing lists",
              textStyle: elevatedbuttonstyle2,
              decoration: BoxDecoration(
                  border: Border.all(color: aubergine, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                  color: satinlin),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ViewScreen();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height / 10),
                      backgroundColor: rosewood,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Image.asset('images/icons/feed.png'),
                      ),
                      Text(
                        'View List',
                        style: elevatedbuttonstyle1,
                      )
                    ],
                  )),
            )
          ],
        ),
      )),
    );
  }
}


// Maybe add history of added items
// add logic to upload stored data if it exists

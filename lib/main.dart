import 'package:flutter/material.dart';
import 'package:shopping_card/database/database_helper.dart';
import 'package:shopping_card/main_screens/home_screen.dart';
import 'package:shopping_card/style/colors.dart';
import 'package:shopping_card/style/decoration.dart';
import 'package:shopping_card/style/textstyle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String? username;
  String? avatarpath;
  bool isUserExists = false;
  @override
  void initState() {
    super.initState();
    _checkUserExists(); // Initiates profile loading when the screen initializes
  }

  Future<void> _checkUserExists() async {
    bool userExists = await DatabaseHelper().isUserExists();

    if (userExists) {
      setState(() {
        isUserExists = true;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isUserExists
            ? const CircularProgressIndicator()
            : Container(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 1,
                decoration: BoxDecoration(
                    image: DecorationImage(image: bgimg, fit: BoxFit.fill)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset('images/shopping-list.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Shopping Card",
                      style: TextStyle(
                          fontFamily: 'Mogra',
                          fontSize: 28,
                          color: aubergine,
                          shadows: [
                            Shadow(
                                color: white,
                                blurRadius: 1.0,
                                offset: const Offset(-2.0, 1))
                          ]),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.of(context).size.width / 2.5,
                                MediaQuery.of(context).size.height / 10),
                            backgroundColor: rosewood,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: aubergine, width: 3.0),
                                borderRadius: BorderRadius.circular(30.0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.asset('images/icons/play.png'),
                            ),
                            Text(
                              'Start',
                              style: elevatedbuttonstyle1,
                            )
                          ],
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shopping_card/database/database_helper.dart';
import 'package:shopping_card/main_screens/home_screen.dart';
import 'package:shopping_card/models/profile.dart';
import 'package:shopping_card/style/colors.dart';
import 'package:shopping_card/style/decoration.dart';
import 'package:shopping_card/style/textstyle.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final TextEditingController nameController = TextEditingController();
  String selectedAvatar = 'images/icons/user.png';

  Future<void> _saveProfile() async {
    Profile profile = Profile(
      userName: nameController.text,
      avatarPath: selectedAvatar,
    );
    await DatabaseHelper().saveProfile(profile); // Save profile to the database
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width / 1,
          height: MediaQuery.of(context).size.height / 1,
          decoration: BoxDecoration(
              image: DecorationImage(image: bgimg, fit: BoxFit.fill)),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('images/shopping-list.png'),
                    ),
                    const SizedBox(width: 10),
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
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextField(
                    controller: nameController,
                    style: semibolditalicsmall,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: rosewood,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: aubergine, width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: aubergine, width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: aubergine, width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: aubergine, width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Enter your name',
                        hintStyle: semibolditalictransmall),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Select an avatar:',
                  style: semibolditalic,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      color: rosewood,
                      border: Border.all(color: aubergine, width: 3),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => setState(
                                () => selectedAvatar = 'images/icons/boy.png'),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor:
                                  selectedAvatar == 'images/icons/boy.png'
                                      ? Colors.green
                                      : Colors.transparent,
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/icons/boy.png'),
                                radius: 30,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => setState(
                                () => selectedAvatar = 'images/icons/girl.png'),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor:
                                  selectedAvatar == 'images/icons/girl.png'
                                      ? Colors.green
                                      : Colors.transparent,
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/icons/girl.png'),
                                radius: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => selectedAvatar =
                                'images/icons/businessman.png'),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: selectedAvatar ==
                                      'images/icons/businessman.png'
                                  ? Colors.green
                                  : Colors.transparent,
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/icons/businessman.png'),
                                radius: 30,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => setState(() =>
                                selectedAvatar = 'images/icons/woman.png'),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor:
                                  selectedAvatar == 'images/icons/woman.png'
                                      ? Colors.green
                                      : Colors.transparent,
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/icons/woman.png'),
                                radius: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() =>
                                selectedAvatar = 'images/icons/student.png'),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor:
                                  selectedAvatar == 'images/icons/student.png'
                                      ? Colors.green
                                      : Colors.transparent,
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/icons/student.png'),
                                radius: 30,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => setState(() =>
                                selectedAvatar = 'images/icons/hijab-girl.png'),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: selectedAvatar ==
                                      'images/icons/hijab-girl.png'
                                  ? Colors.green
                                  : Colors.transparent,
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/icons/hijab-girl.png'),
                                radius: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width / 3.5,
                          MediaQuery.of(context).size.height / 15),
                      backgroundColor: greypink,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: rosewood, width: 2),
                          borderRadius: BorderRadius.circular(20))),
                  child: Text(
                    'Save',
                    style: semibolditalicsmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

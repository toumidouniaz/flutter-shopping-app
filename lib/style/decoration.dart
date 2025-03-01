import 'package:flutter/material.dart';
import 'package:shopping_card/main_screens/favourites.dart';
import 'package:shopping_card/main_screens/home_screen.dart';
import 'package:shopping_card/style/colors.dart';

dynamic bgimg = const AssetImage('images/app_bg3.jpg');

class UpperBarMainScreen {
  final title = 'Shopping Cart';
  AppBar getAppBar(BuildContext context, title) {
    return AppBar(
      backgroundColor: solidpink,
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const ImageIcon(AssetImage('images/icons/angle-left.png')));
      }),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: 32,
            height: 32,
            child: Image.asset('images/shopping-list_outline.png'),
          ),
          Text(
            title,
            style: TextStyle(
                fontFamily: 'Mogra',
                fontSize: 22,
                color: white,
                shadows: [
                  Shadow(
                      color: aubergine,
                      blurRadius: 1.0,
                      offset: const Offset(-2.0, 1.0))
                ]),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FavoritesScreen();
                }));
              },
              icon: Icon(Icons.star_border_rounded, color: white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HomeScreen();
                }));
              },
              icon: Icon(Icons.home, color: white),
            ),
          ],
        )
      ],
    );
  }
}

class UpperBarHomeScreen {
  AppBar getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: solidpink,
      leading: Builder(builder: (BuildContext context) {
        return const SizedBox(
          height: 0.01,
          width: 0.01,
        );
      }),
      title: Expanded(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: 27,
            height: 27,
            child: Image.asset('images/shopping-list_outline.png'),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            "Shopping Card",
            style: TextStyle(
                fontFamily: 'Mogra',
                fontSize: 20,
                color: white,
                shadows: [
                  Shadow(
                      color: aubergine,
                      blurRadius: 1.0,
                      offset: const Offset(-2.0, 1.0))
                ]),
          ),
        ],
      )),
      actions: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FavoritesScreen();
                }));
              },
              icon: Icon(Icons.star_border_rounded, color: white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HomeScreen();
                }));
              },
              icon: Icon(Icons.home, color: white),
            ),
          ],
        )
      ],
    );
  }
}

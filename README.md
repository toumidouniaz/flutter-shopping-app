# shopping_card
A modern and user-friendly shopping list app built with Flutter. This app helps users create and manage shopping lists efficiently by organizing items into markets and categories. It provides a simple, intuitive interface and ensures data persistence using SQLite. 


**Features** 
✅ Create & Manage Shopping Lists – Users can create multiple shopping lists, each associated with a specific market.
✅ Market & Category Organization – Items are categorized within markets for better organization.
✅ Persistent Data Storage – Uses SQLite for mobile & desktop and Hive for web to save user data.
✅ Profile Management – Users can create a profile, which customizes the app experience.
✅ Favorites List – Mark frequently bought items as favorites for quick access.
✅ User-Friendly Interface – Designed with a clean UI, making navigation easy and intuitive.

**Installation** 
1. Clone the Repository
Run this command in Git Bash or your terminal:
git clone https://github.com/toumidouniaz/flutter-shopping-app.git

2. Navigate into the Project Folder
cd flutter-shopping-list

3. Install Dependencies
Ensure you have Flutter installed, then run:
flutter pub get

**Project Structure**
flutter-shopping-list/
│── lib/                 # Main application code
│   ├── main.dart        # Entry point of the app
│   ├── models/          # Data models (Market, Category, Item, Profile)
│   ├── main_screens/    # Main UI screens (Home, Create, View, Favourites, Create Profile)
│   ├── market_screens/  # Market UI Screens (Category, Item)
│   ├── database/        # Database handling (SQLite & Hive)
│   ├── Style/           # Reusable UI components
│── images/              # Images and icons
│── fonts/               # Fonts
│── pubspec.yaml         # Flutter dependencies
│── README.md            # Project documentation
│── .gitignore           # Files to ignore in Git


**Contributing**
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch:
git checkout -b feature-new-feature
3. Make your changes and commit:
git commit -m "Added a new feature"
4. Push the branch and create a pull request.


**License**
This project is open-source under the MIT License.
Some of the icons used like the app logo are from https://www.flaticon.com/
**Attribution:
app logo: <a href="https://www.flaticon.com/free-icons/shopping-list" title="shopping list icons">Shopping list icons created by Freepik - Flaticon</a>
start: <a href="https://www.flaticon.com/free-icons/play-button" title="play-button icons">Play-button icons created by Indra Maulana Yusuf - Flaticon</a>
user avatars: <a href="https://www.flaticon.com/free-icons/user" title="user icons">User icons created by Heykiyou - Flaticon</a>
Uicons by <a href="https://www.flaticon.com/uicons">Flaticon</a>
View list icon: <a href="https://www.flaticon.com/free-icons/files-and-folders" title="files and folders icons">Files and folders icons created by yaicon - Flaticon</a>
open camera: <a href="https://www.flaticon.com/free-icons/camera" title="camera icons">Camera icons created by Good Ware - Flaticon</a>
view image: <a href="https://www.flaticon.com/free-icons/picture" title="picture icons">Picture icons created by Pixel perfect - Flaticon</a>




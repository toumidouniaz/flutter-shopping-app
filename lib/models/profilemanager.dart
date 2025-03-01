import 'package:shopping_card/database/database_helper.dart';
import 'package:shopping_card/models/profile.dart';

class ProfileManager {
  static Future<Profile?> loadProfile() async {
    return await DatabaseHelper().loadProfile();
  }

  static Future<void> saveProfile(String userName, String avatarPath) async {
    Profile profile = Profile(userName: userName, avatarPath: avatarPath);
    await DatabaseHelper().saveProfile(profile);
  }
}

class Profile {
  String userName;
  String avatarPath;

  Profile({required this.userName, required this.avatarPath});

  Map<String, dynamic> toMap() {
    return {'userName': userName, 'avatarPath': avatarPath};
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      userName: map['userName'],
      avatarPath: map['avatarPath'],
    );
  }
}

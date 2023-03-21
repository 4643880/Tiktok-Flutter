class User {
  final String uid;
  final String name;
  final String email;
  final String profilePhoto;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePhoto,
  });

  factory User.fromSnap({required Map<String, dynamic> snapshot}) {
    return User(
      uid: snapshot["uid"],
      name: snapshot["name"],
      email: snapshot["email"],
      profilePhoto: snapshot["profilePhoto"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "profilePhoto": profilePhoto,
      };
}

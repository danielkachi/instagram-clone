import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String? password;
  final String photoUrl;
  final String bio;
  final List following;
  final List followers;

  User({
    required this.username,
    required this.uid,
    required this.email,
    required this.password,
    required this.photoUrl,
    required this.bio,
    required this.following,
    required this.followers,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'photoUrl': photoUrl,
        'password': password,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapShots = (snap.data() as Map<String, dynamic>);

    return User(
        username: snapShots['username'],
        uid: snapShots['uid'],
        email: snapShots['email'],
        password: snapShots['password'],
        photoUrl: snapShots['photoUrl'],
        bio: snapShots['bio'],
        following: snapShots['following'],
        followers: snapShots['followers']);
  }
}

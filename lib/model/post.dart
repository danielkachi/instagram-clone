import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';


class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String  profileImage;
  final likes;

  Post ({

    required this.username,
    required this.uid,
    required this.description,
    required this.postId,
    required this.postUrl,
    required this.likes,
    required this.datePublished,
    required this.profileImage,

  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'description': description,
    'postUrl': postUrl,
    'postId': postId,
    'likes': likes,
    'datePublished': datePublished,
    'profileImage': profileImage,

  };

  static Post fromSnap (DocumentSnapshot snap) {
    var snapShots = (snap.data() as Map <String, dynamic>);

    return Post(
        username: snapShots ['username'],
        uid: snapShots ['uid'],
        postUrl: snapShots ['postUrl'],
        postId: snapShots ['postId'],
        likes: snapShots ['likes'],
        description: snapShots ['description'],
        datePublished: snapShots ['datePublished'],
        profileImage: snapShots ['profileImage']
    );



  }


}
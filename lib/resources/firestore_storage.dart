 import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/model/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreStorage {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future <String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profileImage,
      ) async{
    String res = 'Some error occurred';
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post  = Post(
          username: username,
          uid: uid,
          description: description,
          postId: postId,
          postUrl: photoUrl,
          likes: [],
          datePublished: DateTime.now(),
          profileImage: profileImage,
      );

      _fireStore.collection('posts').doc(postId).set(post.toJson(),);
      res = 'success';
    }catch(err){
      res = err.toString();
    }
    return res;
  }

  // Like Post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if(likes.contains(uid)){
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        }
        );
      } else {
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        }
        );
      }
    } catch (e){
      print(e.toString());

    }
  }

  // Comments

  Future<void> postComments(String postId, String text, String uid,
      String name, String profilePic,) async {
    try{
      if (text.isNotEmpty){
        String commentId = Uuid().v1();
        await _fireStore.collection("posts").doc(postId).collection("comments").doc(commentId).set(
            {
              'profilePic': profilePic,
              'name' : name,
            'uid': uid,
            'text': text,
              'commentId': commentId,
              'datePublished': DateTime.now()
            });
      } else {
        print("Text is empty");
      }
    } catch(e){
      print(e.toString());

    }
  }

//  Delete Posts

  Future<void> deletePosts(String postId) async{
    try{
      await _fireStore.collection('posts').doc(postId).delete();


    } catch(e){
      print(e.toString());
    }


  }


}
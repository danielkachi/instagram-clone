import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/model/user.dart' as model;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';



class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User? currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users')
        .doc(currentUser.uid).get();

    return model.User.fromSnap(snap);


  }

  Future<String?> signUpUser ({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,

}) async {
    String res = 'Some error occurred';
    // print(email);

    try{
      if(email.isNotEmpty ||password.isNotEmpty ||username.isNotEmpty ||bio.isNotEmpty){
         UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

         String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);


        print(credential.user!.uid);


        model.User user = model.User(
          username: username,
          uid: credential.user!.uid,
          email: email,
          password: password,
          photoUrl: photoUrl,
          bio: bio,
          following: [],
          followers: [],
        );





       await _firestore.collection('users').doc(credential.user!.uid).set(user.toJson(),);

       // await _firestore.collection('users').add({
       //   'username': username,
       //   'uid': credential.user!.uid,
       //   'email': email,
       //   'bio': bio,
       //   'followers': [],
       //   'following': [],
       // });


        res = 'successful';

      }

    } catch (error){
      error.toString();
      // res = error.toString();
    }
    print(res);
    return res;

  }

  // create method to login user

Future <String> loginUser({
    required String email,
    required String password,
}) async {
    String res = 'Some error occurred';

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';

      }else{
        res = 'please enter all the fields';
      }

    } on FirebaseAuthException catch(e){
      if(e.code == 'wrong-password'){
        res = 'incorrect password';
      }
    }

    catch (error){
      error.toString();

    }
    return res;

}


}


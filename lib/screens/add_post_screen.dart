


import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/model/user.dart';
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_storage.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}



class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage (
      String username,
      String uid,
      String profileImage,
      ) async{

    setState(() {
      _isLoading = true;
    });

    try {
      String res = await FirestoreStorage().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profileImage,
      );
      if (res == 'success'){
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted!', context);
        clearImage();
      } else{
        setState(() {
          _isLoading = false;
        });

        showSnackBar(res, context);
      }

    } catch (e){
      showSnackBar(e.toString(), context);

    }


  }

  _selectImage(BuildContext context) async{
    return showDialog(context: context, builder: (context) {
      return SimpleDialog(
        title: const Text('create a post'),
        children: [
          // SimpleDialogOption(
          //   padding: EdgeInsets.all(20),
          //   child: Text('Take a photo'),
          //   onPressed: () async {
          //     Navigator.pop(context);
          //     Uint8List file = await pickImage(ImageSource.camera);
          //     setState(() {
          //       _file = file;
          //     });
          //   },
          // ),

          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text('Choose from gallery'),
            onPressed: () async {
              Navigator.pop(context);
              Uint8List file =  await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),

          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('Cancel',
            style: TextStyle(
              color: Colors.blue,
            ),),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

  void clearImage (){
    setState(() {
      _file = null;
    });
}

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final User user = Provider
        .of<UserProvider>(context)
        .getUser;

    return
        _file == null ? Center(
        child: IconButton(
          onPressed: (){
            _selectImage(context);

          },
          icon: const Icon(Icons.upload),),
      )
      : Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: IconButton(
            onPressed: clearImage,
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Post to'),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () => postImage(
                user.username,
                user.uid,
                user.photoUrl,
              ),
              child: const Text('post',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _isLoading? const LinearProgressIndicator() : Padding(
                padding: EdgeInsets.only(top: 0,)),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectImage(context);
                      });
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                  ),
                  SizedBox(width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.45,
                    child: TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.text,
                      maxLines: 15,
                      decoration: InputDecoration(
                        hintText: 'write a caption...',
                        border: InputBorder.none,
                      ),

                    ),
                  ),
                  SizedBox(width: 45,
                    height: 40,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            _selectImage(context);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            )
          ],
        ),
      );
  }
}

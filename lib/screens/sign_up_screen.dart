import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/utils.dart';

import '../utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _usernameController.dispose();

  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;

    });
  }

  signUpUser() async{
    setState(() {
      _isLoading = true;
    });
    String? res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!,
    );



        if (res == 'success'){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>  const ResponsiveLayout(
              webScreenlayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            ),
          ),
          );


    } else {
          showSnackBar(res!, context);

        }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 35,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              Spacer(),
              SvgPicture.asset('assets/images/ic_instagram.svg',
                color: Colors.white,
                height: 64,
              ),
              Spacer(),

              Stack(
                children: [
                  _image != null? CircleAvatar(
                    radius: 64,
                  backgroundImage: MemoryImage(_image!),
                  )
                  :CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage('https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg'),
                  ),

                  Positioned(
                    bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(Icons.add_a_photo,
                        ),
                      ),
                  ),
                ],
              ),
              Spacer(),

               TextField(
                text: 'Enter your username',
                textInputType: TextInputType.text,
                controller: _usernameController,

                // isPass: false,
              ),
              SizedBox(height: 20,),
               TextField(
                text: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                controller: _emailController,
                // isPass: false,
              ),
              SizedBox(height: 25,),
               TextField(
                text: 'Enter your password',
                textInputType: TextInputType.text,
                controller: _passwordController,
                isPass: true,
              ),
              SizedBox(height: 20,),
               TextField(
                text: 'Enter your bio',
                textInputType: TextInputType.text,
                controller: _bioController,
                // isPass: false,
              ),
              SizedBox(height: 25,),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(blueColor),
                      ),
                      onPressed: signUpUser,
                      child:  Padding(
                        padding: EdgeInsets.all(10.0),
                        child: _isLoading ? Center(child: CircularProgressIndicator(
                          color: primaryColor,
                        )):
                        const Text('Sign up',
                          style: TextStyle(
                            color: Colors.white,

                          ),),
                      ),),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen(),),);
                    },
                    child: const Text('Log in.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class TextField extends StatelessWidget {
  const TextField({
    Key? key, required this.text,
    required this.textInputType,
    this.isPass = false,
    required this.controller,
  }) : super(key: key);
  final String text;
  final TextInputType textInputType;
  final bool isPass;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPass,
      enabled: true,
      controller: controller,
      keyboardType: textInputType,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        fillColor: Colors.grey[900],
        filled: true,
        isDense: false,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            5,
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.black,
          ),
        ),
        labelText: text,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),

      ),
    );
  }
}

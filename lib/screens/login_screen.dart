import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/sign_up_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/screens/home_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void loginUser() async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text,

    );

    if (res == 'success')  {
       Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>  ResponsiveLayout(
            webScreenlayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
        ),
      ),
      );
    } else{
      showSnackBar(res, context);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: SvgPicture.asset('assets/images/ic_instagram.svg',
                color: Colors.white,
                height: 64,
                ),
              ),
               TextField(
                text: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                 controller: _emailController,
                // isPass: false,
              ),
              SizedBox(height: 20,),
               TextField(
                text: 'Enter your password',
                textInputType: TextInputType.text,
                 controller: _passwordController,
                 isPass: true,
              ),
              SizedBox(height: 25,),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(blueColor),
                      ),
                        onPressed: loginUser,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: _isLoading? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              )) :
                            Text('Log in',
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()),);
                    },
                    child: const Text('Sign up.',
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
      keyboardType: textInputType,
      controller: controller,
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






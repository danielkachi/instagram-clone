import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/utils/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: 'AIzaSyB0kvewG5Vau7rM5VQa-tDKwgZvMxfTptI',
      appId: '1:331814003838:web:8a0db3c052e1c1ab2ea42f',
      messagingSenderId: '331814003838',
      projectId: 'instagram-clone-c2645',
      storageBucket: 'instagram-clone-c2645.appspot.com',
    ),
    );






  }else{
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  }

  runApp(const MyApp());
}



class MyApp extends StatelessWidget  {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),

        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData){
                  return const ResponsiveLayout(
                      webScreenlayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout()
                  );

                } else if(snapshot.hasError){
                  return Center(
                    child: Text('${snapshot.error}'),
                  );

                }
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );

                }
              return LoginScreen();

            }
        ),
      ),
    );
  }
}

class InstaBuild extends StatefulWidget {
  const InstaBuild({Key? key}) : super(key: key);

  @override
  State<InstaBuild> createState() => _InstaBuildState();
}

class _InstaBuildState extends State<InstaBuild> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp();
  }
}


class TextField extends StatelessWidget {
  const TextField({
    Key? key, required this.text, required this.textInputType
  }) : super(key: key);
  final String text;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      enabled: true,
      keyboardType: textInputType,
      decoration: InputDecoration(
        fillColor: Colors.grey[900],
        filled: true,
        isDense: false,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8,
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


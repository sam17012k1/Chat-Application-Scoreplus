import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scoreplus_chat_app/views/chatrooms.dart';
import 'helper/authenticate.dart';
import 'helper/helperfunctions.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool? userIsLoggedIn;
  bool? isUserExisting;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    setState(() async {
      if(HelperFunctions.getUserLoggedInSharedPreference() != null) {
        userIsLoggedIn =
        (await HelperFunctions.getUserLoggedInSharedPreference())!;
      }else{
        userIsLoggedIn=false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        accentColor: Color(0xff007EF4),
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null ?  userIsLoggedIn! ? ChatRoom() : Authenticate()
          : Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}

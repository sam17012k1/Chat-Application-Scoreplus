
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoreplus_chat_app/helper/helperfunctions.dart';
import 'package:scoreplus_chat_app/services/auth.dart';
import 'package:scoreplus_chat_app/services/database.dart';
import 'package:scoreplus_chat_app/widget/widget.dart';

import 'chatrooms.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthService authService = new AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
              emailEditingController.text.trim(), passwordEditingController.text.trim())
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailEditingController.text.trim());
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Map<String,dynamic> data= userInfoSnapshot.docs[0].data() as Map<String,dynamic>;
          HelperFunctions.saveUserNameSharedPreference(
              data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              data["userEmail"]);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _hiddenText=true;
    String error="";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ApplicationToolbar(),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
      :SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Container(
                  height: 215.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage('assets/images/login_image.png'),
                        fit: BoxFit.fill),
                  )),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                  validator: (val) {
            return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(val!)
            ? null
                : "Please Enter Correct Email";
            },
//    key: _formKey,
              controller: emailEditingController,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                fillColor: Color(0xffF6F6F6),
                filled: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
// key: _formKey,
              validator: (val) => val!.length<=7 ? 'Enter a password 7+ chars long' : null,
              controller: passwordEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xffF6F6F6),
                  filled: true,
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hiddenText = !_hiddenText;
                      });
                    },
                    icon: _hiddenText
                        ? Icon(
                      Icons.remove_red_eye_outlined,
                      color: Color(0xff5db075),
                    )
                        : Icon(
                      Icons.hide_source,
                      color: Color(0xff5bd075),
                    ),
                  )),
              keyboardType: TextInputType.emailAddress,
              obscureText: _hiddenText,
            ),

            SizedBox(
              height: 10,
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red,fontSize: 15),
            ),
            SizedBox(height: 15,),
            Text(
              "Forgot your password?",
              style: TextStyle(color: Color(0xff5db075)),
            ),
            SizedBox(
              height: 80,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 30,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  if(formKey.currentState!.validate()) {
                    signIn();
                  }

                },
                child: Text(
                  "Log in",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
//minimumSize: ,
                    shape: StadiumBorder(),
                    primary: Color(0xff5db075)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.toggleView();
                      });
                    },
                    child: Text(
                      "  Sign up",
                      style: TextStyle(
                          color: Color(0xff5db075),
                          fontWeight: FontWeight.bold),
                    )),
              ],
            )
            ]),
      ),
    ),
    ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoreplus_chat_app/helper/helperfunctions.dart';
import 'package:scoreplus_chat_app/services/auth.dart';
import 'package:scoreplus_chat_app/services/database.dart';

import 'chatrooms.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _hiddenText = true;
  bool _checkbox = true;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController =
      new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signUp() async {

    if(formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });

      await authService.signUpWithEmailAndPassword(emailEditingController.text.trim(),
          passwordEditingController.text.trim()).then((result){
            if(result != null){
              Map<String,String> userDataMap = {
                "userName" : usernameEditingController.text,
                "userEmail" : emailEditingController.text
              };
              print(usernameEditingController.text);
              databaseMethods.addUserInfo(userDataMap);
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text.trim());
              HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text.trim());
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()
              ));
            }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
              child: Text(
                "Sign Up",
                style: TextStyle(
                    color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
              )),
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.white54,

            // Status bar brightness (optional)
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color(0xff5db075)),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  setState(() {
                    widget.toggleView();
                  });
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Color(0xff5db075)),
                ))
          ],
        ),
      body: isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) :
      //   padding: EdgeInsets.symmetric(horizontal: 24),
      //   child: Column(
      //     children: [
      //       Spacer(),
      //       Form(
      //         key: formKey,
      //         child: Column(
      //           children: [
      //             TextFormField(
      //               style: simpleTextStyle(),
      //               controller: usernameEditingController,
      //               validator: (val){
      //                 return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
      //               },
      //               decoration: textFieldInputDecoration("username"),
      //             ),
      //             TextFormField(
      //               controller: emailEditingController,
      //               style: simpleTextStyle(),
      //               validator: (val){
      //                 return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
      //                     null : "Enter correct email";
      //               },
      //               decoration: textFieldInputDecoration("email"),
      //             ),
      //             TextFormField(
      //               obscureText: true,
      //               style: simpleTextStyle(),
      //               decoration: textFieldInputDecoration("password"),
      //               controller: passwordEditingController,
      //               validator:  (val){
      //                 return val.length < 6 ? "Enter Password 6+ characters" : null;
      //               },
      //
      //             ),
      //           ],
      //         ),
      //       ),
      //       SizedBox(
      //         height: 16,
      //       ),
      //       GestureDetector(
      //         onTap: (){
      //           singUp();
      //         },
      //         child: Container(
      //           padding: EdgeInsets.symmetric(vertical: 16),
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(30),
      //               gradient: LinearGradient(
      //                 colors: [const Color(0xff007EF4), const Color(0xff2A75BC)],
      //               )),
      //           width: MediaQuery.of(context).size.width,
      //           child: Text(
      //             "Sign Up",
      //             style: biggerTextStyle(),
      //             textAlign: TextAlign.center,
      //           ),
      //         ),
      //       ),
      //       SizedBox(
      //         height: 16,
      //       ),
      //       Container(
      //         padding: EdgeInsets.symmetric(vertical: 16),
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(30), color: Colors.white),
      //         width: MediaQuery.of(context).size.width,
      //         child: Text(
      //           "Sign Up with Google",
      //           style: TextStyle(fontSize: 17, color: CustomTheme.textColor),
      //           textAlign: TextAlign.center,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 16,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text(
      //             "Already have an account? ",
      //             style: simpleTextStyle(),
      //           ),
      //           GestureDetector(
      //             onTap: () {
      //               widget.toggleView();
      //             },
      //             child: Text(
      //               "SignIn now",
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 16,
      //                   decoration: TextDecoration.underline),
      //             ),
      //           ),
      //         ],
      //       ),
      //       SizedBox(
      //         height: 50,
      //       )
      //     ],
      //   ),
      // ),
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: usernameEditingController,
                  // key: _formKey,
                  // onChanged: (val) {
                  //   setState(() {
                  //     username=val;
                  //   });
                  // },
                  validator: (val) => val!.length<5 ? "Username should be greater than 5 characters" : null ,
                  decoration: InputDecoration(
                    hintText: "Name",
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
                  validator: (val) => val!.isEmpty ? 'Please Enter an Email' : null,
                  // key: _formKey,
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
                  validator: (val) => val!.length<6 ? 'Password should have more than 6 characters' : null,
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
                CheckboxListTile(
                  value: _checkbox,
                  onChanged: (value) => setState(() {
                    _checkbox = value!;
                  }),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    "Recieve promotional information via email updates",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()) {
                        signUp();
                      }
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      //minimumSize: ,
                        shape: StadiumBorder(),
                        primary: Color(0xff5db075)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}

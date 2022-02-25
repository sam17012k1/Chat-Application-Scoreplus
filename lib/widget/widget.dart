import 'package:flutter/material.dart';

class ApplicationToolbar extends StatelessWidget with PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Chat App",
        style: TextStyle(color: Color(0xff5db075)),
      ),
      backgroundColor: Colors.white,

      elevation: 0.0,
      centerTitle: false,
      iconTheme: IconThemeData(
          color: Color(0xff5db075)
      ),
    );
    // TODO: implement build
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

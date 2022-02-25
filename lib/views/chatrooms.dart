
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoreplus_chat_app/helper/authenticate.dart';
import 'package:scoreplus_chat_app/helper/constants.dart';
import 'package:scoreplus_chat_app/helper/helperfunctions.dart';
import 'package:scoreplus_chat_app/helper/theme.dart';
import 'package:scoreplus_chat_app/services/auth.dart';
import 'package:scoreplus_chat_app/services/database.dart';
import 'package:scoreplus_chat_app/views/search.dart';

import 'chat.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream<QuerySnapshot>? chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRooms,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map<String,dynamic> data=(snapshot.data! as QuerySnapshot).docs[index].data() as Map<String,dynamic>;
                  return ChatRoomsTile(
                    userName: data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName,""),
                    chatRoomId: data["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }
  bool isLoading=true;

  @override
  void initState() {
    getUserInfogetChats();

    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    chatRooms=await DatabaseMethods().getUserChats(Constants.myName);
    setState(() {
      isLoading=false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Chat App",style: TextStyle(color: Color(0xff5db075)),),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app,color: Color(0xff5db075),)),
          )
        ],
      ),
      body: Container(
        child: isLoading ? Container(
          child: Center(child: CircularProgressIndicator()),
        ) :  chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName,required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chat(
            chatRoomId: chatRoomId,
          )
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}

import 'package:cookoverflow/helper/constants.dart';
import 'package:cookoverflow/model/user.dart';
import 'package:cookoverflow/services/database.dart';
import 'package:cookoverflow/views/conversationScreen.dart';
import 'package:cookoverflow/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cookoverflow/views/signup.dart';

class Search extends StatefulWidget {
  @override

  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot _searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(searchEditingController.text)
          .then((snapshot){
        _searchResultSnapshot = snapshot;
        print("$_searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
          _searchResultSnapshot = snapshot;

        });
      });
    }
  }

  // Widget userList(){
  //   // Map<String,String> userDataMap{
  //   //  "userName":"ahmad",
  //   //  "email":"ahmadasas",
  //   // };
  //
  //   return haveUserSearched ? ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: _searchResultSnapshot.docs.length,
  //       itemBuilder: (context, index){
  //         return userTile(
  //           // searchResultSnapshot.docs[index].data()["userName"],
  //           //
  //           // searchResultSnapshot.docs[index].data()["email"],
  //
  //           userName= _searchResultSnapshot.data.docs[index]["userName"],
  //           userEmail= _searchResultSnapshot.data.docs[index]["userEmail"],
  //         );
  //       }) ;
  // }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName){
    List<String> users = [Constants.myName,userName];

    String chatRoomId = getChatRoomId(Constants.myName,userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Chat(
          chatRoomId: chatRoomId,
        )
    ));

  }

  Widget userTile(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }


  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :  Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: simpleTextStyle(),
                      decoration: InputDecoration(
                          hintText: "search username ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/search_white.png",
                          height: 25, width: 25,)),
                  )
                ],
              ),
            ),
            // userList()
          ],
        ),
      ),
    );
  }
}
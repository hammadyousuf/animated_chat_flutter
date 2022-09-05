import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
   final messageTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  late String messageText;


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  // void getMesseges() async {
  //    final messeges = await _firestore.collection('messeges').get();
  //    for (var message in messeges.docs) {
  //      print(message.data());
  //    }
  // }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection("messeges").snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  // _auth.signOut();
                  // Navigator.pop(context);
                  messagesStream();
                  //Implement logout functionality
                }),
          ],
          title: Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessegesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        messageTextController.clear();
                        _firestore.collection('messeges').add({
                          'text': messageText,
                          "sender": loggedInUser.email
                        });
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class  MessegesStream extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messeges').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messeges = snapshot.data!.docs;
        List<MessegeBubble> messageBubbles = [];

        for (var messege in messeges) {
          final messageText = messege.data['text'];
          final messegeSender = messege.data['sender'];
           final currentUser = loggedInUser.email;

          final messegeBubble = MessegeBubble(
            sender: messegeSender,
            text: messageText,
            isMe: currentUser == messageBubbles,
          );

          messageBubbles.add(messegeBubble);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessegeBubble extends StatelessWidget {
  MessegeBubble({required this.sender, required this.text, required this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),),
          Material(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
            : BottomRight: Radius.circular(30.0), topRight:Radius.circular(30.0),
        DropdownButton(

            elevation: 5.0,
            color: isMe? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe? Colors.white : Colors.black54 ,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:chat_app/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import '../services/chat services/chat_services.dart';
import 'chat_bubles.dart';

class ChatScreen extends StatefulWidget {
  final String reciverEmail;
  final String reciverid;
  const ChatScreen(
      {super.key, required this.reciverEmail, required this.reciverid});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatServices chatServices = ChatServices();

  AuthService authService = AuthService();
  final messageFocsNode = FocusNode();

  final messageController = TextEditingController();

  void sentMessage() async {
    // if there is something to sent the data
    if (messageController.text.isNotEmpty) {
      chatServices.sentMessage(widget.reciverid, messageController.text);
      messageController.clear();
    }
    scrollDown();
  }

  @override
  void initState() {
    super.initState();
    messageFocsNode.addListener(() {
      if (messageFocsNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future.delayed(Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
    messageFocsNode.dispose();
  }

  // scroll controller

  final scrollController = ScrollController();
  void scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
        title: Text(widget.reciverEmail),
      ),
      body: Column(
        children: [
          // display user message
          Expanded(
            child: _buildMessageList(),
          ),

          // input to sent message
          _buildUserInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: chatServices.getMessage(widget.reciverid, senderId),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CupertinoActivityIndicator();
          }
          return ListView(
            controller: scrollController,
            children: snapshot.data!.docs
                .map((docs) => _buildMessageItem(docs))
                .toList(),
          );
        });
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot docs) {
    Map<String, dynamic> data = docs.data() as Map<String, dynamic>;

    bool iscurrentUser = data["senderId"] == authService.getCurrentUser()!.uid;

    var alignment =
        iscurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          ChatBubles(
            message: data["message"],
            isCurrentUser: iscurrentUser,
            messageId: docs.id,
            userId: docs["senderId"],
          )
        ],
      ),
    );
  }

  // build user input message
  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: MyTextField(
            focusNode: messageFocsNode,
            hintText: 'type a message',
            obsecureText: false,
            controller: messageController,
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(right: 15, bottom: 20),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                  onPressed: sentMessage,
                  icon: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ))),
        )
      ],
    );
  }
}

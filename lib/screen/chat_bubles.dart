// ignore_for_file: must_be_immutable

import 'package:chat_app/services/chat%20services/chat_services.dart';
import 'package:chat_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubles extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;
  ChatBubles(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.userId,
      required this.messageId});

  ChatServices chatServices = ChatServices();

  // show option

  void showOption(BuildContext context, String messageId, userId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              // report message button
              ListTile(
                leading: Icon(Icons.flag),
                title: Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _reportContent(context, messageId, userId);
                },
              ),
              // block user
              ListTile(
                leading: Icon(Icons.block),
                title: Text('Block user'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, userId);
                },
              ),
              // cancel button
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ));
        });
  }

  // report contant

  void _reportContent(BuildContext context, String messageId, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Report message'),
              content: Text('Are you sure you want to report this message'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      chatServices.reportUser(messageId, userId);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Message reported')));
                      Navigator.pop(context);
                    },
                    child: Text('Report')),
              ],
            ));
  }

  // block user
  void _blockUser(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Block user'),
              content: Text('Are you sure you want to Block this user'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      chatServices.blockUsers(userId);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User Blocked')));
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Block user',
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return GestureDetector(
      onLongPress: () {
        showOption(context, messageId, userId);
      },
      child: Container(
        decoration: BoxDecoration(
            color: isCurrentUser
                ? Colors.green
                : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Text(
          message,
          style: TextStyle(
              color: isCurrentUser
                  ? Colors.white
                  : (isDarkMode ? Colors.white : Colors.black)),
        ),
      ),
    );
  }
}

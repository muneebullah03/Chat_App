import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat%20services/chat_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlockUsersSreen extends StatelessWidget {
  BlockUsersSreen({super.key});

  final ChatServices chatServices = ChatServices();
  final AuthService authService = AuthService();
// unblocked box
  showUnblockBox(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Unblock user'),
              content: Text('Are you sure you want to unblock the user'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      chatServices.unblockUser(userId);
                      Navigator.pop(context);
                    },
                    child: Text('Unblock')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final userId = authService.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
        title: Text("block users"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatServices.getBloctUserStream(userId),
          builder: (contex, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading...'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            }
            // return block list

            final blockUser = snapshot.data ?? [];
            if (blockUser.isEmpty) {
              return Center(
                child: Text("No blocked users"),
              );
            }
            // load data

            return ListView.builder(
              itemCount: blockUser.length,
              itemBuilder: (contex, index) {
                final users = blockUser[index];
                return UserTile(
                  onTap: () {
                    showUnblockBox(contex, users['uid']);
                  },
                  text: users['email'],
                );
              },
            );
          }),
    );
  }
}

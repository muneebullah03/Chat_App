// ignore_for_file: collection_methods_unrelated_type

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/my_drawer.dart';
import '../components/user_tile.dart';
import '../services/auth/auth_service.dart';
import '../services/chat services/chat_services.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChatServices chatServices = ChatServices();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
        title: Text(
          'Home',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  // build list of all users except for current user that login in

  Widget _buildUserList() {
    return StreamBuilder(
        stream: chatServices.getAllUsersExcludingBlockUsers(),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            Text('Error');
          }
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          }

          /// return list view
          return ListView(
              children: snapshot.data!
                  .map<Widget>(
                      (userData) => buildUserListItem(userData, context))
                  .toList());
        });
  }

  // build individual list of users

  Widget buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user login
    if (userData["email"] != authService.getCurrentUser()) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          // on tap go to user chat page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        reciverEmail: userData["email"],
                        reciverid: userData["uid"],
                      )));
        },
      );
    } else {
      return Container();
    }
  }
}

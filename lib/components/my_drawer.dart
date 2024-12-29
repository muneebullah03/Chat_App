import 'package:chat_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import '../screen/setting_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void signOut() {
    AuthService authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                    child: ListTile(
                  title: Icon(
                    Icons.message,
                    size: 70,
                    color: isDarkMode ? Colors.grey : Colors.grey,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 70),
                    child: Text(
                      'Muneeb ullah',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                )),
              ),
              // home list tile
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: isDarkMode ? Colors.grey : Colors.black,
                  ),
                  title: Text(
                    'H O M E',
                    style: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // setting listile
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: isDarkMode ? Colors.grey : Colors.black,
                  ),
                  title: Text(
                    'S E T T I N G S',
                    style: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen()));
                  },
                ),
              ),
            ],
          ),
          // lout list tile

          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 20),
            child: ListTile(
              leading: Icon(
                Icons.logout,
              ),
              title: Text('L O G O U T'),
              onTap: signOut,
            ),
          ),
        ],
      ),
    );
  }
}

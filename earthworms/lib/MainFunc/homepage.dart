import 'package:earthworms/FirstP/login_page.dart';
import 'package:earthworms/MainFunc/profilepage.dart';
import 'package:flutter/material.dart';

class homepage extends StatelessWidget {
  homepage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(214, 232, 219, 1),

      //navigation drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(214, 232, 219, 1),
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Change password',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                print('change password');
              },
            ),
            ListTile(
              title: const Text(
                'Log out',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                print("Log out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),

      body: SafeArea(
          child: Column(
        children: [
          //appBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // icon Menu
                IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                      print('Menu');
                    },
                    icon: Icon(
                      Icons.menu,
                      size: 35,
                      color: Colors.grey[800],
                    )),

                // icon profile
                IconButton(
                    onPressed: () {
                      print('Person');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyprofilePage()));
                    },
                    icon:
                        Icon(Icons.person, size: 35, color: Colors.grey[800])),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // text
          Text('Welcome Back')
        ],
      )),
    );
  }
}

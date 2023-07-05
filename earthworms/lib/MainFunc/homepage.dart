import 'package:earthworms/FirstP/login_page.dart';
import 'package:earthworms/MainFunc/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class homepage extends StatelessWidget {
  homepage({super.key});

  String NameDD = 'Ammar Chuapoodee';
  String EmailDD = 'Ammarchsend@gmail.com';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion<SystemUiOverlayStyle>( 
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
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
                child: UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(214, 232, 219, 1)),
                  // Name Header
                  accountName: Text(
                    NameDD,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  // Email Header
                  accountEmail: Text(
                    EmailDD,
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                )),
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
    ));
  }
}

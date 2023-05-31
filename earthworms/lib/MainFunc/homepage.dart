import 'package:flutter/material.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 232, 219, 1),
      body: SafeArea(
        child: Column(
          children: [
            //appBar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // icon Menu
                  IconButton(
                    onPressed: (){
                      Scaffold.of(context).openDrawer();
                    }, 
                    icon: Icon(
                      Icons.menu,
                      size: 38,
                      color: Colors.grey[800],)
                  ),
                  

                  // icon Account
                  IconButton(
                    onPressed: (){

                    },
                    icon: Icon(
                      Icons.person,
                      size: 38,
                      color: Colors.grey[800])
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // text
            Text('Welcome BBack')
            
          ],
        )
      ),
    );
  }
} 
        
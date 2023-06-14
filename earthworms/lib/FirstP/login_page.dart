import 'package:earthworms/FirstP/regis_page.dart';
import 'package:earthworms/MainFunc/homepage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool invisible = true;



  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor:const Color.fromRGBO(214, 232, 219, 1),
      body: SafeArea(
          child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 1),
            if (!isKeyboard)

              //logo
              Image.asset("images/EarthwormIcon.png", height: 250, width: 250),
            const SizedBox(height: 10),

            //Text
            const Text(
              'Welcome back to our Farm!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0e4f55),
                  fontSize: 16),
            ),
            const SizedBox(height: 25),

            //Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextFormField(
                controller: emailController,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffC1D0B5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  fillColor: Color(0xffC1D0B5),
                  filled: true,
                  hintText: 'Email',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),

            //Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffC1D0B5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    fillColor: Color(0xffC1D0B5),
                    filled: true,
                    hintText: 'Password',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: Colors.white),
                    ),
              ),
            ),
            const SizedBox(height: 7),

            //Register button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: const Text('Register'),
                  )
                ],
              ),
            ),

            // Login button
            // ElevatedButton(
            //   onPressed: (){},
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.all(20),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20)
            //     ),
            //     backgroundColor: const Color(0xffA9907E)
            //   ),
            //   child: const Text('Login',
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: const Color(0xffA9907E),
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => homepage()),
                    );
                  },
                  child: const Text('home')),
            )
          ],
        ),
      )),
    );
  }
}

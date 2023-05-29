import 'package:earthworms/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  //text editing controller
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: const Color(0xff675D50),
      ),
      backgroundColor: Color.fromRGBO(214, 232, 219, 1),
      body: SafeArea(
          child: Center(
        child: Column(children: [
          const SizedBox(height: 40),

          // Name
          MyTextField(
              controller: nameController,
              hintText: 'Surename',
              obscureText: false),
          const SizedBox(height: 30),

          // Lastname
          MyTextField(
              controller: lastnameController,
              hintText: 'Lastname',
              obscureText: false),
          const SizedBox(height: 30),

          // Email
          MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false),
              const SizedBox(height: 30),

          // Password
          MyTextField(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true),
            const SizedBox(height: 30)

        ]),
      )),
    );
  }
}

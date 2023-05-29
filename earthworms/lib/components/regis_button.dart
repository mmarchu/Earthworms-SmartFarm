import 'package:flutter/material.dart';

class RegisButton extends StatelessWidget {
  const RegisButton ({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xffA9907E),
          borderRadius: BorderRadius.circular(20)
        ),
        child: const Center(
          child: Text('Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),)
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class AuthContainer extends StatelessWidget {
  const AuthContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25), // Fix: .withAlpha(25) instead of .withOpacity(0.1)
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: child,
    );
  }
}
import 'package:flutter/material.dart';

class HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const HeaderButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(50)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

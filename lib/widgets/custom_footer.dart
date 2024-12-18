import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget implements PreferredSizeWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color.fromRGBO(44, 30, 50, 1),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          '© 2024 Bowling Club. Wszystkie prawa zastrzeżone.',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

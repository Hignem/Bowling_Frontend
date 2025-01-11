import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isLoggedIn = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
      await _checkIfAdmin(token);
    }
  }

  Future<void> _checkIfAdmin(String token) async {
    try {
      final url = 'http://localhost:8080/api/role';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _isAdmin = data['role'] == 'ROLE_ADMIN';
        });
      } else {
        throw Exception('Nie udało się sprawdzić roli użytkownika.');
      }
    } catch (e) {
      print('Błąd podczas sprawdzania roli: $e');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.popAndPushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () => _isLoggedIn
            ? Navigator.pushNamed(context, '/reservation')
            : Navigator.pushNamed(context, '/home'),
        child: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromRGBO(44, 30, 50, 1),
      actions: [
        if (_isLoggedIn) ...[
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/history'),
            child: const Text(
              'Historia zamówień',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: _logout,
            child: const Text(
              'Wyloguj się',
              style: TextStyle(color: Colors.white),
            ),
          )
        ] else ...[
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text(
              'Logowanie',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: const Text(
              'Rejestracja',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ],
    );
  }
}

import 'package:bowling_frontend/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Aby korzystać z BackdropFilter

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Bowling Club'),
      body: Stack(
        children: [
          // Tło z obrazkiem
          Positioned.fill(
            child: Image.asset(
              'assets/bowling_inside.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Nakładka z efektem przyciemnienia i blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Rozmycie
              child: Container(color: Color.fromRGBO(0, 0, 0, 0.5)
                  // Przyciemnienie tła
                  ),
            ),
          ),
          // Treść na tle (tekst i przycisk)
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Witaj w naszym Klubie Kręglarskim!\nZarezerwuj tor i baw się świetnie z przyjaciółmi.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      'Zaloguj się',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color.fromRGBO(44, 30, 50, 1),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            '© 2024 Bowling Club. Wszystkie prawa zastrzeżone.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

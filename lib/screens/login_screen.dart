import 'dart:ui';
import 'package:bowling_frontend/widgets/custom_app_bar.dart';
import 'package:bowling_frontend/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final response = await http.post(
        Uri.parse('http://localhost:8080/api/login'), // Twoje API
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final token = responseData['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        Navigator.pushReplacementNamed(context, '/reservation');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nie udało się zalogować. Spróbuj ponownie.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Bowling Club'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bowling_inside.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: SizedBox(
                    width: 600,
                    child: Container(
                      padding: EdgeInsets.all(24.0),
                      margin: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Zaloguj się',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.white12,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Proszę wprowadzić adres email';
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$")
                                    .hasMatch(value)) {
                                  return 'Proszę wprowadzić prawidłowy adres email';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Hasło',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.white12,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Proszę wprowadzić hasło';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24.0),
                            ElevatedButton(
                              onPressed: _login,
                              child: Text('Zaloguj się'),
                            ),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text(
                                'Nie masz konta? Zarejestruj się',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 600,
                    ),
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}

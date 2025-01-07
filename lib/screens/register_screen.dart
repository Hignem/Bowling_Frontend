import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bowling_frontend/widgets/custom_app_bar.dart';
import 'package:bowling_frontend/widgets/custom_footer.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      print('Formularz poprawnie zwalidowany');
      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;

      final Uri url = Uri.parse('http://localhost:8080/api/register');

      final Map<String, dynamic> payload = {
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'email': email,
        'admin': false,
        'isAdmin': false,
      };

      try {
        final http.Response response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pushNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Błąd rejestracji: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wystąpił błąd: $e')),
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
                color: Color.fromRGBO(0, 0, 0, 0.5),
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
                              'Zarejestruj się',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Proszę wprowadzić imię';
                                      }
                                    },
                                    controller: _firstNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Imię',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.white12,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Proszę wprowadzić nazwisko';
                                      }
                                    },
                                    controller: _lastNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Nazwisko',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.white12,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
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
                              onPressed: _register,
                              child: Text('Zarejestruj się'),
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

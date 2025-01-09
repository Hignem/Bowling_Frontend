import 'dart:math';

import 'package:bowling_frontend/widgets/custom_app_bar.dart';
import 'package:bowling_frontend/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key? key}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? _firstName;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Brak tokena, użytkownik nie jest zalogowany.');
      }
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _firstName = data['firstName'];
        });
      } else {
        throw Exception('Błąd pobierania profilu: ${response.statusCode}');
      }
    } catch (e) {
      print('Błąd: $e');
    }
  }

  DateTime? _selectedDate;

  // Lista godzin otwarcia klubu
  final List<String> _availableHours =
      List.generate(11, (index) => '${12 + index}:00');

  // Wybrana godzina
  String? _selectedHour;

  // Lista kortów
  List<Map<String, dynamic>> _lanes = [];

  Future<void> _fetchLanes() async {
    if (_selectedDate == null || _selectedHour == null) {
      // Nie pobieraj danych, jeśli brak daty lub godziny
      setState(() {
        _lanes = [];
      });
      return;
    }
    final String formattedDateTime =
        '${_selectedDate!.toIso8601String().split("T").first}T$_selectedHour:00';

    print('Formatted DateTime: $formattedDateTime');

    try {
      print(formattedDateTime);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/api/alley/available/$formattedDateTime'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> lanes = jsonDecode(response.body);
        setState(() {
          _lanes =
              lanes.map((lane) => Map<String, dynamic>.from(lane)).toList();
        });
      } else {
        throw Exception('Błąd pobierania kortów: ${response.statusCode}');
      }
    } catch (e) {
      print('Błąd: $e');
      setState(() {
        _lanes = [];
      });
    }
  }

  // Wybrany kort
  String? _selectedLane;

  // Funkcja otwierająca DatePicker
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      await _fetchLanes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Bowling Club'),
      body: Stack(
        children: [
          // Tło ze zdjęciem
          Positioned.fill(
            child: Image.asset(
              'assets/bowling_inside.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Rozmycie tła
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          ),
          // Panel rezerwacji
          Center(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(24.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _firstName != null
                        ? 'Witaj $_firstName, zarezerwuj kort'
                        : 'Witaj użytkowniku, zarezerwuj kort ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24.0),

                  // Wybór daty
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pickDate,
                          child: Text(
                            _selectedDate == null
                                ? 'Wybierz datę'
                                : '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white12,
                            border: OutlineInputBorder(),
                            labelText: 'Wybierz godzinę',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          dropdownColor: Colors.grey[800],
                          value: _selectedHour,
                          items: _availableHours.map((hour) {
                            return DropdownMenuItem<String>(
                              value: hour,
                              child: Text(hour,
                                  style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            setState(() {
                              _selectedHour = value;
                            });
                            await _fetchLanes();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  const Text(
                    'Wybierz kort:',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  const SizedBox(height: 12.0),
                  _lanes.isEmpty
                      ? const Text(
                          'Wybierz datę i godzinę, aby zobaczyć dostępne korty.',
                          style: TextStyle(color: Colors.white),
                        )
                      : Wrap(
                          spacing: 12.0,
                          children: _lanes.map((lane) {
                            final bool isAvailable = lane['isAvailable'];
                            return ChoiceChip(
                              label: Text(lane['name']),
                              selected: _selectedLane == lane['id'],
                              selectedColor: Colors.blueAccent,
                              onSelected: isAvailable
                                  ? (selected) {
                                      setState(() {
                                        _selectedLane =
                                            selected ? lane['id'] : null;
                                      });
                                    }
                                  : null,
                              labelStyle: TextStyle(
                                color: _selectedLane == lane
                                    ? Colors.white
                                    : Colors.deepPurple,
                              ),
                            );
                          }).toList(),
                        ),

                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}

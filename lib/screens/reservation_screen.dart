import 'dart:math';

import 'package:bowling_frontend/widgets/custom_app_bar.dart';
import 'package:bowling_frontend/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key? key}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  // Wybrana data
  DateTime? _selectedDate;

  // Lista godzin otwarcia klubu
  final List<String> _availableHours =
      List.generate(11, (index) => '${12 + index}:00');

  // Wybrana godzina
  String? _selectedHour;

  // Lista kortów
  final List<String> _lanes = [
    'Kort 1',
    'Kort 2',
    'Kort 3',
    'Kort 4',
    'Kort 5'
  ];

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
                  const Text(
                    'Zarezerwuj kort',
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

                  // Wybór godziny
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
                          onChanged: (value) {
                            setState(() {
                              _selectedHour = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Wybór kortu
                  const Text(
                    'Wybierz kort:',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 12.0,
                    children: _lanes.map((lane) {
                      return ChoiceChip(
                        label: Text(lane),
                        selected: _selectedLane == lane,
                        selectedColor: Colors.blueAccent,
                        onSelected: (selected) {
                          setState(() {
                            _selectedLane = selected ? lane : null;
                          });
                        },
                        labelStyle: const TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24.0),

                  // Przycisk rezerwacji
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedDate != null &&
                          _selectedHour != null &&
                          _selectedLane != null) {
                        // Tutaj dodaj logikę rezerwacji
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Rezerwacja: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}, '
                              'Godzina: $_selectedHour, Kort: $_selectedLane',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Wypełnij wszystkie pola!')),
                        );
                      }
                    },
                    child: const Text('Zarezerwuj'),
                  ),
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

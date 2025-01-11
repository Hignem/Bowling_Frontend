import 'dart:convert';
import 'dart:ui';
import 'package:bowling_frontend/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  List<Map<String, dynamic>> _lanes = [];

  @override
  void initState() {
    super.initState();
    _fetchLanes();
  }

  Future<void> _fetchLanes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Brak tokena, użytkownik nie jest zalogowany.');
      }

      final response = await http.get(
        Uri.parse('http://localhost:8080/api/alley'),
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
        throw Exception('Błąd pobierania torów: ${response.statusCode}');
      }
    } catch (e) {
      print('Błąd: $e');
      setState(() {
        _lanes = [];
      });
    }
  }

  Future<void> _deleteLane(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/alley/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tor został pomyślnie usunięty.'),
          ),
        );
        setState(() {
          _lanes.removeWhere((lane) => lane['id'] == id);
        });
      } else {
        print('Błąd usuwania toru: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nie udało się usunąć toru. Spróbuj ponownie.'),
          ),
        );
      }
    } catch (e) {
      print('Błąd: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wystąpił błąd podczas usuwania toru.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Panel Administratora'),
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
          Center(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.7),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap:
                        true, // dostosowuje wysokosc listy do zawartosci, bez tego nic sie nie wyswietla
                    itemCount: _lanes.length,
                    itemBuilder: (context, index) {
                      final lane = _lanes[index];
                      return Card(
                        color: const Color.fromRGBO(44, 30, 50, 1),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            'Tor: ${lane['name']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //dzieci wstawiane sa od poczatku (lewej strony)
                            children: [
                              Text(
                                'Cena: ${lane['price']} zł',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              Text(
                                'Max osób: ${lane['maxPersons']}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          trailing: Row(
                            //trailing - dzieki temu te przyciski znajduja sie po prawej stronie, przeciwienstwo leading
                            mainAxisSize: MainAxisSize.min,
                            //dzieci maja zajmowac jak najmniej miejsca
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // _addOrEditLane();
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteLane(lane['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // _addOrEditLane();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 20.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Dodaj tor',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

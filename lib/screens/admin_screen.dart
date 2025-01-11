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

  Future<void> addLane(BuildContext context) async {
    try {
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => LaneWindow(),
      );
      // jesli uzytkownik nacisnie anuluj nie wyrzuci bledu
      if (result == null) return;

      // Pobierz token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Użytkownik nie jest zalogowany.');
      }

      // Wykonaj żądanie POST
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/alley'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(result),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dodano tor.')),
        );

        await _fetchLanes();
      } else {
        throw Exception('Błąd dodawania toru: ${response.statusCode}');
      }
    } catch (e) {
      // Obsługa błędów
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wystąpił błąd: $e')),
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
                      //tutaj trzeba wywolac prawidlowo ta funkcje
                      addLane(context);
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

class LaneWindow extends StatelessWidget {
  final Map<String, dynamic>? lane;
  //? - moze przyjac null, bo wykorzystujemy ten widget do edycji i dodawaniu

  LaneWindow({this.lane}); //konstruktor obiektu

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _maxPersonsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //TextEditingController nie moze miec null, wiec jesli bedzie taka sytuacja przypiszemy ''
    if (lane != null) {
      _nameController.text = lane!['name'] ?? '';
      _priceController.text = lane!['price']?.toString() ?? '';
      _maxPersonsController.text = lane!['maxPersons']?.toString() ?? '';
    }

    return AlertDialog(
      title: Text(lane != null ? 'Edytuj tor' : 'Dodaj tor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nazwa toru'),
          ),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Cena'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _maxPersonsController,
            decoration: const InputDecoration(labelText: 'Max osób'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final price = _priceController.text.trim();
            final maxPersons = _maxPersonsController.text.trim();

            if (name.isEmpty || price.isEmpty || maxPersons.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Wszystkie pola muszą być wypełnione!')),
              );
              return; // Przerywamy dalsze działanie
            }
            final result = {
              // jesli edytujemy wstawiamy id zaciagniete juz wczesniej
              if (lane != null) 'id': lane!['id'],
              'name': _nameController.text,
              'price': double.tryParse(_priceController.text) ?? 0.0,
              'maxPersons': int.tryParse(_maxPersonsController.text) ?? 0,
            };
            Navigator.pop(context, result);
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}

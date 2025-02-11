import 'dart:convert';

import 'package:bowling_frontend/widgets/custom_app_bar.dart';
import 'package:bowling_frontend/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  List<Map<String, dynamic>> _orders = [];
  Future<void> _fetchHistory() async {
    setState(() {
      _orders = [];
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/reservation/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> orders = jsonDecode(response.body);
        print(orders);
        setState(() {
          _orders = orders.map((order) {
            final reservationDateTime =
                DateTime.parse(order['reservationDateTime']);

            final orderDateTime = DateTime.parse(order['orderDateTime']);

            return {
              'id': order['id'],
              'reservationDate':
                  reservationDateTime.toIso8601String().split('T')[0],
              'reservationTime': reservationDateTime
                  .toIso8601String()
                  .split('T')[1]
                  .substring(0, 5),
              'alleyId': order['alleyId'],
              'maxPersons': order['maxPersons'],
              'price': order['price'],
              'orderDate': orderDateTime.toIso8601String().split('T')[0],
            };
          }).toList();
        });
      } else {
        throw Exception('Błąd pobierania historii: ${response.statusCode}');
      }
    } catch (e) {
      print('Błąd: $e');
    }
  }

  Future<void> _cancelReservation(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/reservation/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Anulowano rezerwacje!'),
          ),
        );
        Navigator.popAndPushNamed(context, "/history");
      } else {
        throw Exception(
            'Błąd podczas anulowania rezerwacji: ${response.statusCode}');
      }
    } catch (e) {
      print('Błąd: $e');
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
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blueGrey),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Data rezerwacji',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Godzina',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Kort',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Max. osób',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Cena',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Data zamówienia',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Anulowanie ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: _orders.map((order) {
                    return DataRow(
                      cells: [
                        DataCell(Center(
                          child: Text(
                              DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(order['reservationDate'])),
                              style: const TextStyle(color: Colors.white)),
                        )),
                        DataCell(Center(
                          child: Text(order['reservationTime'],
                              style: const TextStyle(color: Colors.white)),
                        )),
                        DataCell(Center(
                          child: Text(order['alleyId'].toString(),
                              style: const TextStyle(color: Colors.white)),
                        )),
                        DataCell(Center(
                          child: Text(order['maxPersons'].toString(),
                              style: const TextStyle(color: Colors.white)),
                        )),
                        DataCell(Center(
                          child: Text(order['price'].toString(),
                              style: const TextStyle(color: Colors.white)),
                        )),
                        DataCell(Center(
                          child: Text(
                              DateFormat('dd-MM-yyyy')
                                  .format(DateTime.parse(order['orderDate'])),
                              style: const TextStyle(color: Colors.white)),
                        )),
                        DataCell(Center(
                          child: DateTime.parse(order['reservationDate'])
                                  .isAfter(DateTime.now())
                              ? ElevatedButton(
                                  onPressed: () {
                                    _cancelReservation(order['id']);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              : SizedBox(),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}

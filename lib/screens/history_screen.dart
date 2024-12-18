import 'package:bowling_frontend/widgets/custom_app_bar.dart';
import 'package:bowling_frontend/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> orders = [
      {
        'orderDate': '2024-05-01',
        'reservationDate': '2024-05-10',
        'time': '14:00',
        'lane': 'Kort 1',
        'price': '50 PLN',
      },
      {
        'orderDate': '2024-04-28',
        'reservationDate': '2024-05-05',
        'time': '18:00',
        'lane': 'Kort 3',
        'price': '60 PLN',
      },
      {
        'orderDate': '2024-04-20',
        'reservationDate': '2024-04-25',
        'time': '16:00',
        'lane': 'Kort 2',
        'price': '55 PLN',
      },
    ];

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
                        'Data zamówienia',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                        'Cena',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: orders.map((order) {
                    return DataRow(
                      cells: [
                        DataCell(Text(order['orderDate']!,
                            style: const TextStyle(color: Colors.white))),
                        DataCell(Text(order['reservationDate']!,
                            style: const TextStyle(color: Colors.white))),
                        DataCell(Text(order['time']!,
                            style: const TextStyle(color: Colors.white))),
                        DataCell(Text(order['lane']!,
                            style: const TextStyle(color: Colors.white))),
                        DataCell(Text(order['price']!,
                            style: const TextStyle(color: Colors.white))),
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

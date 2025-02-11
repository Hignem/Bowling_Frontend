import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const BowlingReservationApp());
}

class BowlingReservationApp extends StatelessWidget {
  const BowlingReservationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bowling Reservation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: AppRoutes.routes,
    );
  }
}

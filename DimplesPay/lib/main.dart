import 'package:dimplespay/Pages/Gift.dart';
import 'package:dimplespay/Pages/NFC_page.dart';
import 'package:flutter/material.dart';
import 'Models/user_model.dart';
import 'Pages/dashboard.dart';
import 'Pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(), // Point d'entrée de l'application
    );
  }
}
class Main extends StatefulWidget {
  const Main({super.key});
  @override
  MainState createState() => MainState();
}

class MainState extends State<Main>{
  int currentIndex = 0;
  static final User staticvalde = User(
    name: 'Fouda Dzou',
    email: 'foudadzou@example.com',
    balance: 15000.50,
    transactions: [
      Transaction(date: '2024-12-01', amount: 200.00),
      Transaction(date: '2024-11-30', amount: 50.75),
      Transaction(date: '2024-11-29', amount: 100.00),
    ],
  );

  final List<Widget> pages = [
    Dashboard(staticvalde),
    const NFC(),
    const Gift(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex], // Affiche la page correspondant à l'index actuel
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex, // Index actif
        onTap: (index) {
          setState(() {
            currentIndex = index; // Change l'index actif et met à jour l'UI
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nfc),
            label: 'NFC',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Gift',
          ),
        ],
      ),
    );
  }
}


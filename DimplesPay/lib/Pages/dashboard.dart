import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Models/user_model.dart';
import 'package:http/http.dart' as http;


class Dashboard extends StatefulWidget {
  final User userData;
  const Dashboard(this.userData, {super.key});
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState  extends State<Dashboard>{
  double walletBalance = 0.0; // Initial wallet balance
  String errorMessage = '';// Initial wallet balance
  bool isLoading = true; // Loading state
 // Loading state

  final User userData = User(
    name: 'Fouda Dzou',
    email: 'foudadzou@example.com',
    balance: 15000.50,
    transactions: [
      Transaction(date: '2024-12-01', amount: 200.00),
      Transaction(date: '2024-11-30', amount: 50.75),
      Transaction(date: '2024-11-29', amount: 100.00),
    ],
  );

  @override
  void initState() {
    super.initState();
    fetchWalletBalance();// Fetch balance when the screen loads
  }

 

  /// Fetch wallet balance from API
  Future<void> fetchWalletBalance() async {
    if (kDebugMode) {
      print('fetchWalletBalance called');
    }
    final url = Uri.parse('https://mockapi.example.com/wallet/balance'); // Replace with actual API endpoint
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          walletBalance = data['balance'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch wallet balance.';
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('initState valdez');
      }
        setState(() {
          errorMessage = 'An error occurred: $e';
          isLoading = false;
        });
    }
  }

  /// Fetch topUpWallet balance from API
  Future<void> topUpWallet(double amount) async {
    final url = Uri.parse('https://mockapi.example.com/wallet/topup'); // Mock API endpoint

    try {
      print('Attempting to top-up wallet...');
      final response = await http.post(
        url,
        body: json.encode({'amount': amount}),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Top-up successful: $data');

        setState(() {
          walletBalance += amount; // Mise à jour du solde localement
          isLoading = false;
        });

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wallet topped up successfully by \$${amount.toStringAsFixed(2)}!')),
        );
      } else {
        print('Failed response: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to top up wallet: ${response.body}')),
        );
      }
    } catch (e) {
      print('Exception occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while topping up: $e')),
      );
    }
  }

  void showTopUpDialog() {
    double topUpAmount = 0.0; // Montant par défaut

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Top Up Wallet'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter amount',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              topUpAmount = double.tryParse(value) ?? 0.0;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                if (topUpAmount > 0) {
                  topUpWallet(topUpAmount); // Appeler la méthode de recharge
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter a valid amount.')),
                  );
                }
              },
              child: const Text('Top Up'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text(
              'Dashboard',
            style: TextStyle(
                fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: Container(
          color: const Color(0XFFFFFFFFF),
          child:  Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.deepPurple, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome, ${userData.name}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                      fontFamily: 'Arial',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Wallet Balance:  \$ ${walletBalance.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.lightBlue,
                                    ),
                                  )
                                ]
                            ),
                          ),
                        ),
                    )
                  ]
                  ),
                const SizedBox(height: 20),
                // Recent Transactions Section
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 10),
                // Transactions List
                Expanded(
                  child: ListView.builder(
                    itemCount: userData.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = userData.transactions[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF6C63FF),
                            child: Icon(
                              Icons.attach_money,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            '\$${transaction.amount}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(transaction.date),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: showTopUpDialog, // Ouvrir la boîte de dialogue de recharge
                  icon: const Icon(Icons.add),
                  label: const Text('Top Up Wallet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFFFF),
                    side: const BorderSide(color: Colors.green, width: 1),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}




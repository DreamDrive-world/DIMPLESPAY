import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class NFC extends StatefulWidget {
  const NFC({super.key});

  @override
    NFCState createState() => NFCState();
}

class NFCState extends State<NFC> {
   String nfcCardId = "";
   double nfcCardBalance = 0.0;
   double walletBalance = 0.0;

  Future<void> activateCard() async {
    final url = Uri.parse('https://mockapi.example.com/nfc/activate');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
           nfcCardId = data['card_id'];
           nfcCardBalance = 0.0; // Initial balance after activation
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NFC Card activated successfully!')),
        );
      } else {
        throw Exception('Failed to activate card');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  Future<void> fetchCardDetails() async {
    final url = Uri.parse('https://mockapi.example.com/nfc/details');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          nfcCardId = data['card_id'];
          nfcCardBalance = data['balance'];
        });
      } else {
        throw Exception('Failed to fetch card details');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  Future<void> topUpCard(double amount) async {
    final url = Uri.parse('https://mockapi.example.com/nfc/topup');
    try {
      final response = await http.post(
        url,
        body: json.encode({'amount': amount}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          nfcCardBalance += amount;
          walletBalance -= amount;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully topped up \$${amount.toStringAsFixed(2)} to NFC card!')),
        );
      } else {
        throw Exception('Failed to top up card');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  Future<void> deductCardBalance(double amount, String pin) async {
     final url = Uri.parse('https://mockapi.example.com/nfc/deduct');
     try {
       final response = await http.post(
         url,
         body: json.encode({'amount': amount, 'pin': pin}),
         headers: {'Content-Type': 'application/json'},
       );

       if (response.statusCode == 200) {
         setState(() {
           nfcCardBalance -= amount;
         });

         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Successfully deducted \$${amount.toStringAsFixed(2)}!')),
         );
       } else {
         throw Exception('Failed to deduct balance');
       }
     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error: $e')),
       );
     }
   }
   void showTopUpDialog() {
     double topUpAmount = 0.0;

     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text('Top Up NFC Card'),
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
               onPressed: () => Navigator.of(context).pop(),
               child: const Text('Cancel'),
             ),
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
                 if (topUpAmount > 0 && topUpAmount <= walletBalance) {
                   topUpCard(topUpAmount);
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
   void showDeductDialog() {
     double deductAmount = 0.0;
     String pin = '';

     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text('Deduct NFC Card Balance'),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               TextField(
                 keyboardType: TextInputType.number,
                 decoration: const InputDecoration(
                   labelText: 'Enter amount',
                   border: OutlineInputBorder(),
                 ),
                 onChanged: (value) {
                   deductAmount = double.tryParse(value) ?? 0.0;
                 },
               ),
               const SizedBox(height: 10),
               TextField(
                 obscureText: true,
                 decoration: const InputDecoration(
                   labelText: 'Enter PIN',
                   border: OutlineInputBorder(),
                 ),
                 onChanged: (value) {
                   pin = value;
                 },
               ),
             ],
           ),
           actions: [
             TextButton(
               onPressed: () => Navigator.of(context).pop(),
               child: const Text('Cancel'),
             ),
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
                 if (deductAmount > 0 && deductAmount <= nfcCardBalance && pin.isNotEmpty) {
                   deductCardBalance(deductAmount, pin);
                 } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Invalid input.')),
                   );
                 }
               },
               child: const Text('Deduct'),
             ),
           ],
         );
       },
     );
   }



   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'NFC',
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
         color: Colors.white,
         child:  Padding(
           padding: const EdgeInsets.all(16.0),
           child:Column(
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   ElevatedButton(
                     onPressed: fetchCardDetails,
                     child: const Text('Card Details'),
                   ),
                   ElevatedButton(
                     onPressed: activateCard,
                     child: const Text('Activate NFC Card'),
                   ),
                 ],
               ),
               const SizedBox(height: 10),
               Row(
                 children: [
                   Expanded(
                     child: Card(
                       elevation: 0,
                       shape: RoundedRectangleBorder(
                         side: const BorderSide(color: Colors.blueGrey, width: 1),
                         borderRadius: BorderRadius.circular(8),
                       ),
                       color: Colors.white,
                       child: Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                   'Card ID: $nfcCardId',
                                   style: const TextStyle(
                                     fontSize: 16,
                                     fontFamily: 'Arial',
                                   )
                               ),
                               const SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   const Text(
                                       'Card Balance: ',
                                       style: TextStyle(
                                           fontSize: 20,
                                           fontFamily: 'Arial',
                                           color: Colors.deepPurple,
                                           fontWeight: FontWeight.bold
                                       )
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 15),
                                     child:
                                     Text(
                                         '\$${nfcCardBalance.toStringAsFixed(2)}',
                                         style: const TextStyle(
                                             fontSize: 20,
                                             fontFamily: 'Arial',
                                             fontWeight: FontWeight.bold
                                         )
                                     ),
                                   )
                                 ],
                               )
                             ]
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
               ElevatedButton(
                 onPressed: showDeductDialog,
                 child: const Text('Deduct Balance'),
               ),
             ],
           ),
         ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showTopUpDialog,
        child: Icon(Icons.add), // Icône du bouton
      ),
    );
  }

}
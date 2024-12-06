import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Gift extends StatelessWidget {
  const Gift({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        title: const Text(
          'GIFT',
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
      body: const Text('VALDEZ'),
    );
  }

}
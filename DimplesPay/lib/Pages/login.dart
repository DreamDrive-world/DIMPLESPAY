import 'package:dimplespay/main.dart';
import 'package:flutter/material.dart';
import '../Models/user_model.dart';
import '../Service/api_service.dart';
import 'dashboard.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    final result = await ApiService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Main(),
        // builder: (context) => Dashboard(userData: result['data']),
      ),
    );

    // if (result != null && result['success']) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => Dashboard(userData: result['data']),
    //     ),
    //   );
    // }
    // else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(result?['message'] ?? 'Login failed')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center( child:Text('Login'),)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

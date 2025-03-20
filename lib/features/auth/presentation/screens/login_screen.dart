import 'package:flutter/material.dart';

import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';

class LoginScreen extends StatefulWidget {
  final SignIn signIn;
  final SignUp signUp;

  const LoginScreen({
    super.key,
    required this.signIn,
    required this.signUp,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    try {
      await widget.signIn(
          SignInParams(email: _emailController.text, password: _passwordController.text));
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _signUp() async {
    try {
      await widget.signUp(
          SignUpParams(email: _emailController.text, password: _passwordController.text));
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _isSigningUp = !_isSigningUp;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSigningUp ? 'Sign Up' : 'Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSigningUp ? _signUp : _signIn,
              child: Text(_isSigningUp ? 'Sign Up' : 'Login'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _toggleAuthMode,
              child: Text(_isSigningUp
                  ? 'Already have an account? Login'
                  : 'Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
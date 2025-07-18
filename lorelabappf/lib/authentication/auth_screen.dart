import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lorelabappf/ui/main_navigation.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
      errorMessage = null;
    });
  }

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
          throw FirebaseAuthException(code: 'password-mismatch', message: 'Passwords do not match');
        }
        await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigation()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  isLogin ? "Welcome Back" : "Create Account",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: emailController,
                  validator: (value) => value!.isEmpty ? 'Enter email' : null,
                  decoration: _inputDecoration("Email"),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? 'Password too short' : null,
                  decoration: _inputDecoration("Password"),
                  style: TextStyle(color: Colors.white),
                ),
                if (!isLogin) ...[
                  SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Confirm password' : null,
                    decoration: _inputDecoration("Confirm Password"),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
                SizedBox(height: 20),
                if (errorMessage != null)
                  Text(errorMessage!, style: TextStyle(color: Colors.red)),
                SizedBox(height: 10),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: handleSubmit,
                        child: Text(isLogin ? "Sign In" : "Sign Up"),
                      ),
                TextButton(
                  onPressed: toggleForm,
                  child: Text(
                    isLogin
                        ? "Don't have an account? Sign Up"
                        : "Already have an account? Sign In",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

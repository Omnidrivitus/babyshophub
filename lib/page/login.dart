import 'package:babyshophub/components/Mytextfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

final usernameController = TextEditingController();
final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        // Makes centr
        child: Center(
          child: Column(
            children: [
              //Logo
              Icon(Icons.lock, size: 100),
              const SizedBox(height: 50),

              //text
              Text(
                "Welcome to BabyShop",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(height: 25),

              //username
              MyTextField(
                controller: usernameController,
                hintText: "Username",
                obscureText: false,
              ),

              const SizedBox(height: 10),
              //password
              MyTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 10),

              //forgot password
              Text("Forgot Password?", style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 25),
              //sign in button
              
            ],
          ),
        ),
      ),
    );
  }
}

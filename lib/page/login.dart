import 'package:babyshophub/components/Mytextfield.dart';
import 'package:babyshophub/components/button.dart';
import 'package:babyshophub/data/repository/auth_repository.dart';
import 'package:babyshophub/data/service/api_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //sign in method
  Future<void> loginUser() async {
    //

    String email = emailController.value.text;
    String password = passwordController.value.text;

    String token = await ApiService().loginUser(email, password);

    PreferencesRepository appState = PreferencesRepository();
    appState.setToken(token);

    debugPrint(appState.getToken());
  }

  void registerUserPage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        // Makes centr
        child: SingleChildScrollView(
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
                  controller: emailController,
                  hintText: "Email",
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
                Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 25),

                //sign in button
                MyButton(onTap: loginUser, name: "login"),
                const SizedBox(height: 25),

                //alternatives
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),

                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(onTap: registerUserPage, name: "register"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

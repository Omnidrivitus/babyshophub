import 'package:babyshophub/components/Mytextfield.dart';
import 'package:babyshophub/components/button.dart';
import 'package:babyshophub/data/service/api_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in method
  Future<void> registerUser(BuildContext context) async {
    //

    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    await ApiService().registerUser(context, name, email, password);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                const SizedBox(height: 50),

                //Logo
                Icon(Icons.home, size: 50),
                const SizedBox(height: 50),

                //text
                Text(
                  "Welcome to BabyShop Register",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),

                //username
                MyTextField(
                  controller: nameController,
                  hintText: "John Doe",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: emailController,
                  hintText: "johndoe@gmail.com",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //password
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                //sign in button
                MyButton(onTap: () => registerUser(context), name: "register"),
                const SizedBox(height: 25),

                //alternatives
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                // MyButton(onTap: l, name: "login"), // Route to login pge
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? token;
  const ResetPasswordPage({super.key, this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleReset() async {
    setState(() => _isLoading = true);
    // create and call your ApiService.resetPassword(widget.token, _passwordController.text)
    // Then context.go('/login')
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Token: ${widget.token!.substring(1, 8)}"),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleReset,
              child: const Text("Update Password"),
            ),
          ],
        ),
      ),
    );
  }
}

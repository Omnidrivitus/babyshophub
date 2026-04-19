import 'package:babyshophub/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void onPressed(BuildContext context) async {
    try {
      await PreferencesRepository().clearToken();
      if (context.mounted) context.go('/login');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('There was an error, try again')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Home Page"),
            IconButton(
              onPressed: () => onPressed(context),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}

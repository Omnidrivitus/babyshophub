import 'dart:convert';
import 'package:babyshophub/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://babyshop.aptech.osii.me/api";

  Future<void> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': "application/json"},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      debugPrint('sucess');
      final Map<String, dynamic> data = jsonDecode(response.body);
      PreferencesRepository appState = PreferencesRepository();

      appState.setToken(data['token']);
    } else if (response.statusCode == 401) {
      debugPrint('fail');

      if (!context.mounted) return;
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String errorMessage = data['message'];

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } else {
      debugPrint('fail');

      throw Exception("Failed to login: ${response.statusCode}");
    }
  }

  Future<void> loginUserFromRegister(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': "application/json"},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      debugPrint('sucess');
      final Map<String, dynamic> data = jsonDecode(response.body);
      PreferencesRepository appState = PreferencesRepository();

      appState.setToken(data['token']);
    } else if (response.statusCode == 401) {
      debugPrint('fail');
    } else {
      debugPrint('fail');

      throw Exception("Failed to login: ${response.statusCode}");
    }
  }

  Future<void> registerUser(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/register'),
      headers: {'Content-Type': "application/json"},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      debugPrint('sucess');

      loginUserFromRegister(email, password);
    } else {
      debugPrint('fail');
      throw Exception("Failed to login: ${response.statusCode}");
    }
  }
}

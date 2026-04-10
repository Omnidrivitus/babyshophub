import 'dart:convert';
import 'dart:io';
import 'package:babyshophub/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://babyshop.aptech.osii.me/api';

  Future<void> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (!context.mounted) return;
    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      PreferencesRepository appState = PreferencesRepository();

      await appState.setToken(data['token']);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sucess')));
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'])));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('There was an error')));
    }
  }

  Future<void> loginUserFromRegister(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      PreferencesRepository appState = PreferencesRepository();

      await appState.setToken(data['token']);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      throw Exception('There was an error ${HttpStatus.unauthorized}');
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
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
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (!context.mounted) return;
    if (response.statusCode == HttpStatus.created) {
      try {
        await loginUserFromRegister(email, password);
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'There was an error ${response.body} ${e.toString()}',
            ),
          ),
        );
      }
    } else if (response.statusCode == HttpStatus.badRequest) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('There was an error ${response.body}')),
      );
    }
  }
}

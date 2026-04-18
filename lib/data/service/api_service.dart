import 'dart:convert';
import 'dart:io';
import 'package:babyshophub/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://babyshop.aptech.osii.me/api';

  Future<bool> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (!context.mounted) return false;
    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      PreferencesRepository appState = PreferencesRepository();

      await appState.setToken(data['token']);
      if (!context.mounted) return false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Success')));
      return true;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Unauthorized')),
      );
      return false;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('There was an error')));
      return false;
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

  Future<bool> registerUser(
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
    if (!context.mounted) return false;
    if (response.statusCode == HttpStatus.created) {
      try {
        await loginUserFromRegister(email, password);
        return true;
      } catch (e) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'There was an error ${response.body} ${e.toString()}',
            ),
          ),
        );
        return false;
      }
    } else if (response.statusCode == HttpStatus.badRequest) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'] ?? 'Bad request')));
      return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('There was an error ${response.body}')),
      );
      return false;
    }
  }

  // cart api

  Future<Map<String, dynamic>> getMyCart() async {
    final token = PreferencesRepository().getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No auth token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/cart'),
      headers: _authHeaders(token),
    );

    if (response.statusCode == HttpStatus.ok) {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw Exception('Invalid cart response format.');
    }

    throw Exception(
      _extractErrorMessage(response, fallback: 'Failed to fetch cart'),
    );
  }

  Future<Map<String, dynamic>> addItemToCart({
    required int productId,
    required int quantity,
  }) async {
    final token = PreferencesRepository().getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No auth token found. Please login first.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/cart/add'),
      headers: _authHeaders(token),
      body: jsonEncode({'productId': productId, 'quantity': quantity}),
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'message': 'Item added to cart successfully.'};
    }

    throw Exception(
      _extractErrorMessage(response, fallback: 'Failed to add item to cart'),
    );
  }

  Future<Map<String, dynamic>> checkoutCart() async {
    final token = PreferencesRepository().getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No auth token found. Please login first.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/cart/checkout'),
      headers: _authHeaders(token),
    );

    if (response.statusCode == HttpStatus.ok) {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'message': 'Checkout successful'};
    }

    throw Exception(
      _extractErrorMessage(response, fallback: 'Checkout failed'),
    );
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    final token = PreferencesRepository().getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No auth token found. Please login first.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: _authHeaders(token),
    );

    if (response.statusCode == HttpStatus.ok) {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw Exception('Invalid profile response format.');
    }

    throw Exception(
      _extractErrorMessage(response, fallback: 'Failed to fetch profile'),
    );
  }

  Map<String, String> _authHeaders(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  String _extractErrorMessage(
    http.Response response, {
    required String fallback,
  }) {
    try {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final dynamic message = decoded['message'] ?? decoded['error'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      return '$fallback (${response.statusCode})';
    } catch (_) {
      return '$fallback (${response.statusCode})';
    }
  }
}

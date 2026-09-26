import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiClient {
  final String _baseUrl;
  
  String get baseUrl => _baseUrl;

  ApiClient() : _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000';

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: _mergeHeaders(headers),
    );
    return _processResponse(response);
  }

  Future<dynamic> post(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: _mergeHeaders(headers),
      body: body != null ? jsonEncode(body) : null,
    );
    return _processResponse(response);
  }
  
  Future<dynamic> put(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: _mergeHeaders(headers),
      body: body != null ? jsonEncode(body) : null,
    );
    return _processResponse(response);
  }
  
  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: _mergeHeaders(headers),
    );
    return _processResponse(response);
  }

  Map<String, String> _mergeHeaders(Map<String, String>? customHeaders) {
    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Attach Supabase token if available
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null && session.accessToken.isNotEmpty) {
      defaultHeaders['Authorization'] = 'Bearer ${session.accessToken}';
    }

    if (customHeaders != null) {
      defaultHeaders.addAll(customHeaders);
    }
    return defaultHeaders;
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}

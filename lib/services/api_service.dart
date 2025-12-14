import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/ot_list_model.dart';

class ApiService {
  static const String _baseUrl = 'https://cancerreg.org/anae';
  static const Duration _timeout = Duration(seconds: 30);

  // Singleton instance
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // HTTP client
  final http.Client _client = http.Client();

  // Headers
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Get OT List
  Future<OtListResponse> getOtList({
    int page = 1,
    int itemsPerPage = 10,
    Map<String, dynamic>? filters,
  }) async {
    try {
      // Build query parameters
      final queryParams = {
        'page': page.toString(),
        'limit': itemsPerPage.toString(),
      };
      
      if (filters != null) {
        filters.forEach((key, value) {
          if (value != null) {
            queryParams[key] = value.toString();
          }
        });
      }

      final uri = Uri.parse('$_baseUrl/sample.json').replace(
        queryParameters: queryParams,
      );

      final response = await _client
          .get(uri, headers: _headers)
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OtListResponse.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load OT list. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } on TimeoutException catch (e) {
      throw Exception('Request timeout: $e');
    } on FormatException catch (e) {
      throw Exception('Invalid JSON format: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // You can add more API methods here as needed
}
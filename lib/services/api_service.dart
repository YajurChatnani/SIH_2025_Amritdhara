import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import '../model/calculation_result.dart';

class SmartApiService {
  static const int port = 5000;
  static const String endpoint = '/api';

  // Fallback URLs to try
  static const List<String> fallbackUrls = [
    'https://your-deployed-backend.com/api', // Your cloud deployment
    'http://192.168.1.100:5000/api',         // Common local IP
    'http://10.0.2.2:5000/api',             // Android emulator
    'http://127.0.0.1:5000/api',            // iOS simulator
  ];

  String? _detectedBaseUrl;
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<String> _discoverBackend() async {
    // Return cached URL if already found
    if (_detectedBaseUrl != null) {
      print('🔄 Using cached backend URL: $_detectedBaseUrl');
      return _detectedBaseUrl!;
    }

    print('🔍 Discovering backend server...');

    // Try to get device's network info for smart detection
    try {
      final wifiIP = await _networkInfo.getWifiIP();
      if (wifiIP != null) {
        // Generate likely backend IPs based on device IP
        final subnet = wifiIP.substring(0, wifiIP.lastIndexOf('.'));
        final smartUrls = [
          'http://$subnet.1:$port$endpoint',    // Router IP
          'http://$subnet.100:$port$endpoint',  // Common dev machine IP
          'http://$subnet.101:$port$endpoint',
          'http://$subnet.102:$port$endpoint',
        ];

        // Try smart URLs first
        for (final url in smartUrls) {
          if (await _testConnection(url)) {
            _detectedBaseUrl = url;
            print('✅ Found backend at: $url');
            return url;
          }
        }
      }
    } catch (e) {
      print('⚠️ Network info detection failed: $e');
    }

    // Try fallback URLs
    for (final url in fallbackUrls) {
      if (await _testConnection(url)) {
        _detectedBaseUrl = url;
        print('✅ Found backend at: $url');
        return url;
      }
    }

    throw Exception('❌ No backend server found. Please ensure your backend is running.');
  }

  Future<bool> _testConnection(String baseUrl) async {
    try {
      print('🧪 Testing: $baseUrl/health');
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 3));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<FeasibilityResponse> calculateFeasibility(FeasibilityRequest request) async {
    try {
      final baseUrl = await _discoverBackend();

      print('🔄 Starting API call...');
      print('📍 URL: $baseUrl/feasibility');
      print('📊 Request data: ${request.toJson()}');

      final response = await http.post(
        Uri.parse('$baseUrl/feasibility'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - backend may be slow');
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📝 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('✅ Successfully parsed response');
        return FeasibilityResponse.fromJson(data);
      } else {
        print('❌ API Error - Status: ${response.statusCode}');
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'] ?? 'Unknown error occurred';
        print('❌ Error message: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Exception in calculateFeasibility: $e');
      // Clear cached URL on error to retry discovery next time
      _detectedBaseUrl = null;
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final baseUrl = await _discoverBackend();
      return await _testConnection(baseUrl);
    } catch (e) {
      return false;
    }
  }

  // Force rediscovery (useful for testing)
  void clearCache() {
    _detectedBaseUrl = null;
    print('🔄 Cleared backend URL cache');
  }
}
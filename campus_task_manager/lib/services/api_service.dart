import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<dynamic>?> fetchRandomQuote() async {
    try {
      final response = await http
          .get(Uri.parse('https://zenquotes.io/api/random'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }

      return null;
    } catch (e) {
      print('API Error: $e');
      return null;
    }
  }
}

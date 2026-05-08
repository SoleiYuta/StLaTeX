import 'dart:convert';
import 'dart:io';

import '../models/strategy.dart';

class StrategyApi {
  StrategyApi({
    this.baseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://127.0.0.1:8000',
    ),
  });

  final String baseUrl;

  Future<Strategy> fetchLatestStrategy() async {
    final client = HttpClient();
    try {
      final request =
          await client.getUrl(Uri.parse('$baseUrl/strategies/latest'));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode != HttpStatus.ok) {
        return Strategy.fallback();
      }

      return Strategy.fromJson(jsonDecode(body) as Map<String, dynamic>);
    } catch (_) {
      return Strategy.fallback();
    } finally {
      client.close();
    }
  }
}

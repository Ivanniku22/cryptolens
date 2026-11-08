
import 'package:dio/dio.dart';

class CoinPaprikaService {
  final Dio _dio;

  CoinPaprikaService(this._dio);

  Future<List<dynamic>> getTickers() async {
    try {
      final response = await _dio.get(
        '/coins',
        queryParameters: {
          'quotes': 'USD',
        },
      );

      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch cryptocurrency data: ${e.message}',
      );
    }
  }

  Future<Map<String, dynamic>> getCoinDetails(String coinId) async {
    try {
      final response = await _dio.get('/coin-info/$coinId');

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch coin details: ${e.message}',
      );
    }
  }

  Future<Map<String, dynamic>> getTickerById(String coinId) async {
    try {
      final response = await _dio.get('/coins/$coinId');

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch coin ticker: ${e.message}',
      );
    }
  }

  Future<List<dynamic>> getHistoricalTickers(
      String coinId, {
        required String start,
        required String interval,
      }) async {
    try {
      final response = await _dio.get(
        '/coins/$coinId/historical',
        queryParameters: {
          'start': start,
          'interval': interval,
          'quote': 'usd',
        },
      );

      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch historical price data: ${e.message}',
      );
    }
  }
}

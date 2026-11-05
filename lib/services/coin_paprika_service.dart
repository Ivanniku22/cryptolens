import 'package:dio/dio.dart';

class CoinPaprikaService {
  final Dio _dio;

  CoinPaprikaService(this._dio);

  Future<List<dynamic>> getTickers() async {
    try {
      final response = await _dio.get(
        '/tickers',
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
      final response = await _dio.get('/coins/$coinId');

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch coin details: ${e.message}',
      );
    }
  }


  Future<Map<String, dynamic>> getTickerById(String coinId) async {
    try {
      final response = await _dio.get('/tickers/$coinId');

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch coin ticker: ${e.message}',
      );
    }
  }


}
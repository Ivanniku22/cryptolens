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
}
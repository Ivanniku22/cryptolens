
import '../../services/coin_paprika_service.dart';
import '../models/coin_model.dart';

class CoinRepository {
  final CoinPaprikaService _service;

  CoinRepository(this._service);

  Future<List<CoinModel>> getCoins() async {
    final response = await _service.getTickers();

    return response
        .map((coin) => CoinModel.fromJson(coin))
        .toList();
  }


  Future<CoinModel> getCoinById(String coinId) async {
    final response = await _service.getTickerById(coinId);

    return CoinModel.fromJson(response);
  }

  Future<Map<String, dynamic>> getCoinDetails(String coinId) async {
    return await _service.getCoinDetails(coinId);
  }

}

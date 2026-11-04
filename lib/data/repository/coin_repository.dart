
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
}

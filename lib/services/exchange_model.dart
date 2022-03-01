import 'package:bitcoin_ticker/services/networking.dart';

class ExchangeModel {
  Future<dynamic> getCoinFiatData(String coin_id, String fiat) async {
    Uri url = Uri.http('api.coingecko.com', '/api/v3/simple/price', {
      'ids': coin_id.toLowerCase(),
      'vs_currencies': fiat.toLowerCase(),
    });

    print('URL:: $url');
    Networking networking = Networking(url: url);

    var symbolFiatData = await networking.getData();
    print('SymbolFiatData: $symbolFiatData');
    return symbolFiatData;
  }
}

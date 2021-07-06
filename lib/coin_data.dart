import 'package:http/http.dart' as HttpHelper;
import 'dart:convert';

const apiKey = '';
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<Map<String, int>> getCoinData(String selectedCurrency) async {
    dynamic data;
    Map<String, int> rates = Map();

    for (String crypto in cryptoList) {
      Uri uri = Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=$apiKey');

      HttpHelper.Response response = await HttpHelper.get(uri);

      if (response.statusCode != 200) {
        print('error');
      } else {
        data = jsonDecode(response.body);
        double rate = data['rate'];
        rates[crypto] = rate.round();
      }
    }
    return rates;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bitcoin_price_checker/coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Map<String, int> cryptoAndRates = Map();
  String? currency = '';

  DropdownButton<String> AndroidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems
          .add(DropdownMenuItem(child: Text(currency), value: currency));
    }

    return DropdownButton<String>(
      value: currency,
      items: dropdownItems,
      onChanged: (value) {
        if (value != null) getData(value);
      },
    );
  }

  CupertinoPicker IOSPicker() {
    List<Widget> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        getData(currenciesList[selectedIndex]);
      },
      children: pickerItems,
    );
  }

  void getData(String selectedCurrency) async {
    Map<String, int> data = await CoinData().getCoinData(selectedCurrency);
    setState(() {
      cryptoAndRates = data;
      currency = selectedCurrency;
    });
  }

  List<Widget> CurrencyCards() {
    List<Padding> currencyCards = [];
    for (String crypto in cryptoList) {
      currencyCards.add(Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 BTC = ${cryptoAndRates[crypto]} $currency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }
    return currencyCards;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData('USD');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: CurrencyCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? IOSPicker() : AndroidDropdownButton(),
          ),
        ],
      ),
    );
  }
}

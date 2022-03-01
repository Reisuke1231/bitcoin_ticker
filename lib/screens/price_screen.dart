import 'dart:io' show Platform;

import 'package:bitcoin_ticker/services/exchange_model.dart';
import 'package:bitcoin_ticker/utilities/coin_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCoin = 'Bitcoin';
  String selectedFiat = 'USD';
  String coinPrice = '---';

  ExchangeModel exchangeModel = ExchangeModel();

  initState() {
    super.initState();

    setState(() {
      setCoinPrice(selectedCoin, selectedFiat);
    });
  }

  Future<void> setCoinPrice(String selectedCoin, String selectedFiat) async {
    dynamic cryptoCurrencyData =
        await exchangeModel.getCoinFiatData(selectedCoin, selectedFiat);

    print('cryptoCurrencyData: $cryptoCurrencyData');

    var tmpCoinPrice = cryptoCurrencyData[selectedCoin.toLowerCase()]
        [selectedFiat.toLowerCase()];

    setState(() {
      coinPrice = tmpCoinPrice.toString();

      print('COIN PRICE: $coinPrice');
    });
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItemList = [];
    for (String currencyCode in currenciesList) {
      var currency = DropdownMenuItem(
        child: Text(currencyCode),
        value: currencyCode,
      );

      dropdownItemList.add(currency);
    }

    return DropdownButton<String>(
      value: selectedFiat,
      items: dropdownItemList,
      onChanged: (value) {
        setState(() {
          selectedFiat = value!;
          setCoinPrice(selectedCoin, selectedFiat);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $selectedCoin = $coinPrice $selectedFiat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

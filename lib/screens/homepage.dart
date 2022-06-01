import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_learning/screens/exchange_rate_screen.dart';
import 'package:flutter_learning/services/http_services.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  HTTPService? _http;
  late String _coinName;
  String _languageChoice = "en";
  late Map _exchangeRates;
  TextEditingController searchBarController = TextEditingController();

  _HomePageState() {
    //Default Settings
    _coinName = "bitcoin";
    _languageChoice = "en";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _searchBar(),
                  _dataWidgets(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return SizedBox(
      width: 350,
      child: TextField(
        controller: searchBarController,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          label: const Text(
            "Search Bar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          fillColor: Colors.white,
          suffix: IconButton(
              onPressed: () {
                setState(() {
                  //Remove Keyboard after Pressing Search Icon
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  _coinName = searchBarController.text.toLowerCase();
                });
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          hintText: "What cryptocurrency do you want to see?",
          // border: const OutlineInputBorder(
          //   borderSide: BorderSide(
          //     width: 2,
          //   ),
          //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> _coins = [
      'bitcoin',
      'ethereum',
      'tether',
      'ariva',
      'solana',
      'dogecoin',
      'dai',
    ];

    List<DropdownMenuItem<String>> _items = _coins
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ),
            ))
        .toList();
    return DropdownButton(
      items: _items,
      value: _coinName,
      onChanged: (_value) {
        setState(() {
          _coinName = _value.toString();
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_circle_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
        future: _http!.get("/coins/$_coinName"),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            Map _data = jsonDecode(_snapshot.data.toString());
            num _usdPrice = _data["market_data"]["current_price"]["usd"];
            num _change24h =
                _data["market_data"]["price_change_percentage_24h"];
            String _img = _data["image"]["large"];
            String _coinDescribe = _data["description"][_languageChoice];

            //Exchange Rates
            _exchangeRates = _data["market_data"]["current_price"];

            if (_coinDescribe == "") {
              _coinDescribe =
                  "This API has not provided a/an $_languageChoice description at this time";
            } else if (_languageChoice != "en" &&
                _coinDescribe == _data["description"]["en"]) {
              _coinDescribe =
                  "The $_languageChoice translation provided by this API is the same with the English one";
            }

            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _coinImageWidget(_img),
                _currentPriceWidget(_usdPrice),
                _percentageChangeWidget(_change24h),
                _coinDescriptionWidget(_coinDescribe),
                _buttonRow()
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
        });
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "Current Price: ${_rate.toStringAsFixed(2)}USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      "% Change: ${_change.toString()}%",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _coinImageWidget(String _imgUrl) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.07,
        horizontal: _deviceHeight! * 0.07,
      ),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        image: DecorationImage(image: NetworkImage(_imgUrl)),
      ),
    );
  }

  Widget _coinDescriptionWidget(String _description) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: _deviceHeight! * 0.01,
      ),
      margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.05),
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      color: const Color.fromRGBO(83, 88, 206, 0.5),
      child: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _description,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonRow() {
    List<String> _langList = [
      'en',
      'fr',
      'es',
      'de',
      'it',
      'ko',
    ];

    List<DropdownMenuItem<String>> _languages = _langList
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w300),
              ),
            ))
        .toList();

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext _context) {
                  return ExchangeRateScreen(
                      rates: _exchangeRates, name: _coinName);
                }));
              },
              child: const Text("See Exchange Rates")),
          DropdownButton(
            items: _languages,
            value: _languageChoice,
            onChanged: (_value) {
              setState(() {
                _languageChoice = _value.toString();
              });
            },
            dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
            iconSize: 25,
            icon: const Icon(
              Icons.arrow_drop_down_circle_sharp,
              color: Colors.white,
            ),
            underline: Container(),
          )
        ]);
  }
}

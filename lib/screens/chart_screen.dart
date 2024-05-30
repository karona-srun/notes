import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import '../app_colors.dart';
import 'package:flutter/material.dart';

import '../data/ad_helper.dart';
import 'display_chart.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen>
    with SingleTickerProviderStateMixin {

  String testDevice = 'YOUR_DEVICE_ID';
  int maxFailedLoadAttempts = 3;
  String loading = 'loading Ads';
  late AnimationController _animationController;
  var getMonthFormatter = DateFormat('MM');
  var getYearFormatter = DateFormat('yyyy');

  Map<String, double> dailyAmounts = {};
  List<Map<String, dynamic>> _dataList = [];

  final DateTime _now = DateTime.now();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int _selectedMonth = 01;
  int _selectedYear = 2024;
  late int indexMonth;
  late String indexYear;

  String _choiceType = 'ចំណូល/ចំណាយ';
  String _choiceYear = 'ឆ្នាំ';
  String _choiceMonth = 'ខែ';

  List<String> _listType = ['ចំណូល/ចំណាយ', 'ប្រភេទ', 'កាលបរិច្ចេទ'];
  List<String> _listMonthKH = [
    'មករា',
    'កុម្ភៈ',
    'មិនា',
    'មេសា',
    'ឧសភា',
    'មិថុនា',
    'កក្កដា',
    'សីហា',
    'កញ្ញា',
    'តុលា',
    'វិច្ឆិកា',
    'ធ្នូ'
  ];

  int endYear = DateTime.now().year;
  List<String> _listYear = [];

  List<String> generateYearsList() {
    List<String> lst = [];
    int startYear = endYear - 6;
    for (int year = endYear; year >= startYear; year--) {
      lst.add(year.toString());
    }
    return lst;
  }

  @override
  void initState() {
    _createInterstitialAd();
    _createBottomBannerAd();
    Intl.defaultLocale = 'en';
    String month = getMonthFormatter.format(_now);
    String year = getYearFormatter.format(_now);
    _selectedMonth = int.parse(month);
    _selectedYear = int.parse(year);
    _listYear = generateYearsList();
    setState(() {
      indexMonth = _selectedMonth + 1;
      _startDate = DateTime(_selectedYear, _selectedMonth, 1);
      _endDate = DateTime(_selectedYear, _selectedMonth + 1, 0);
      _choiceType = _listType[0];
      _choiceYear = _selectedYear.toString();
      _choiceMonth = _listMonthKH[_selectedMonth - 1];
    });
    print('${_startDate} ${_endDate} ${_choiceType}' +
        '-' +
        '${_choiceYear}' +
        '-' +
        '${_choiceMonth}');
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _animationController.addStatusListener((status) {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _getDataFromNotes(_choiceType, _startDate, _endDate);
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bottomBannerAd.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  String formatDate(String dateString) {
    DateTime originalDate = DateFormat('dd-MMM-yyyy').parse(dateString);
    String formattedDate = DateFormat('dd-MMM').format(originalDate);
    return formattedDate;
  }

  _getDataFromNotes(String type, DateTime startDate, DateTime endDate) {
    DatabaseReference starCountRef = FirebaseDatabase.instance
        .ref("users-${FirebaseAuth.instance.currentUser?.uid}");

    starCountRef.onValue.listen((DatabaseEvent event) {
      var snapshotValue = event.snapshot.value;
      List<Map<String, dynamic>> temp = [];
      setState(() {
        _dataList.clear();
      });

      String str = type == "ប្រភេទ"
          ? "category"
          : type == "កាលបរិច្ចេទ"
              ? "pickupDate"
              : "type";
      if (snapshotValue != null && snapshotValue is Map) {
        Iterable dataList = snapshotValue.values;

        DateTime date = DateTime.parse(startDate.toString());

        // Format the DateTime object to "MMM-yyyy" format
        String formattedDate = DateFormat('MMM-yyyy').format(date);

        Iterable filteredDataList = dataList.where((item) {
          // Extract month and year from pickupDate
          List<String> parts = item["pickupDate"].split("-");
          String monthYear = "${parts[1]}-${parts[2]}"; // Month-Year format

          // Check if month and year match the desired month and year
          return monthYear == formattedDate;
        }).toList();

        print('filteredDataList $filteredDataList');

        Map<String, double> sumByPickupDate = {};

        for (var transaction in filteredDataList) {
          // Extract pickup date and amount
          String pickupDate = transaction[str];
          double amount = double.parse(transaction["amount"]);

          // Add the amount to the sum for the pickup date
          sumByPickupDate.update(pickupDate, (value) => value + amount,
              ifAbsent: () => amount);
        }

        print('sumByPickupDate $sumByPickupDate');

        sumByPickupDate.forEach((key, value) {
          temp.add({
            'time': key.toString(),
            'value': value.toStringAsFixed(2),
          });
        });

        setState(() {
          _dataList = temp;
        });

        print('_dataList  $_dataList');
      } else {
        if (kDebugMode) {
          print('itemList is not found');
        }
      }
    });
  }

  DateTime _parseDateString(String dateString) {
    final format = DateFormat('dd-MMM-yyyy', 'en_US');
    return format.parse(dateString);
  }

  List<Map<String, dynamic>> filterDataByCategory(String category) {
    return _dataList.where((data) => data['category'] == category).toList();
  }

  bool refreshSecondScreen = false;
  void refresh() {
    setState(() {
      refreshSecondScreen = !refreshSecondScreen;
    });
  }
  
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  static AdRequest request = const AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
            loading = 'Show Ads';
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myColorBackground,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 15),
                      child: GestureDetector(
                        child: const Icon(Icons.arrow_back_ios,
                            color: Colors.black),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 15),
                      child: Text(
                        'ក្រាបស្ថិតិ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: 'Hanuman',
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: AppColors.myColorBlack),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 15),
                      child: GestureDetector(
                        child: Image.asset(
                          "assets/images/icon/icons8-filter-64.png",
                          width: 24,
                          color: Colors.white,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                Text(
                  'ក្រាបបង្ហាញទិន្នន័យពីប្រតិបត្តិការ',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: 'Hanuman',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: AppColors.myColorBlack),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 0),
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        dropDownButtonsType(_listType, _choiceType),
                        dropDownButtonsYear(_listYear, _choiceYear),
                        dropDownButtonsMonth(_listMonthKH, _choiceMonth),
                      ],
                    ),
                  ),
                ),
                _dataList.isEmpty
                    ? SizedBox(
                        height: 250,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 70),
                              child: Center(
                                  child: Image.asset(
                                      "assets/images/icon/loading.gif")),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 40),
                              child: const Text(
                                'កំពុងទាញទិន្នន័យ....',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Hanuman'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 300,
                        child: DisplayChart(
                          myDataList: _dataList, refresh: refresh
                        ),
                      ),
                  
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _isBottomBannerAdLoaded
            ? SizedBox(
                height: _bottomBannerAd.size.height.toDouble(),
                width: _bottomBannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bottomBannerAd),
              )
            : TextButton(onPressed: _showInterstitialAd, child: Text(loading, style: TextStyle(
              fontFamily: 'Hanuman',
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: AppColors.myColorBlack),
              ),
            ),
      
    );
  }

  dropDownButtonsType(List<String> list, String hint) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 15, bottom: 24, top: 24),
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width / 3,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Color(0xFFF2F2F2)),
        child: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.grey[50],
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,
              )),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              elevation: 0,
              icon: Image.asset(
                "assets/images/icon/up_and_down_arrow.png",
                width: 20,
              ),
              iconEnabledColor: const Color(0xFF595959),
              items: list.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 15, fontFamily: 'Hanuman'),
                  ),
                );
              }).toList(),
              hint: Text(
                hint,
                style: const TextStyle(
                    color: Colors.black, fontSize: 15, fontFamily: 'Hanuman'),
              ),
              onChanged: (String? value) async {
                setState(() {
                  _choiceType = value.toString();
                  _dataList.clear();
                });
                _getDataFromNotes(_choiceType, _startDate, _endDate);
                DisplayChart(myDataList: _dataList, refresh: refresh);
              }, // setting hint
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownButtonsYear(List<String> list, String hint) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 15, bottom: 24, top: 24),
      child: Container(
        height: 40,
        width: 120,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Color(0xFFF2F2F2)),
        child: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.grey[50],
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,
              )),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              elevation: 0,
              icon: Image.asset(
                "assets/images/icon/up_and_down_arrow.png",
                width: 20,
              ),
              iconEnabledColor: const Color(0xFF595959),
              items: list.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Hanuman'),
                  ),
                );
              }).toList(),
              hint: Text(
                hint,
                style: const TextStyle(
                    color: Colors.black, fontSize: 15, fontFamily: 'Hanuman'),
              ),
              onChanged: (String? value) {
                print('object $value');

                setState(() {
                  indexYear = value.toString();
                  _choiceYear = value.toString();
                  _dataList.clear();
                  _startDate =
                      DateTime(int.parse(_choiceYear), indexMonth + 1, 1);
                  _endDate =
                      DateTime(int.parse(_choiceYear), indexMonth + 2, 0);
                });
                _getDataFromNotes(_choiceType, _startDate, _endDate);
                DisplayChart(myDataList: _dataList, refresh: refresh);
              }, // setting hint
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownButtonsMonth(List<String> list, String hint) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 15, bottom: 24, top: 24),
      child: Container(
        height: 40,
        width: 100,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Color(0xFFF2F2F2)),
        child: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.grey[50],
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,
              )),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              elevation: 0,
              icon: Image.asset(
                "assets/images/icon/up_and_down_arrow.png",
                width: 20,
              ),
              iconEnabledColor: const Color(0xFF595959),
              items: list.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 15, fontFamily: 'Hanuman'),
                  ),
                );
              }).toList(),
              hint: Text(
                hint,
                style: const TextStyle(
                    color: Colors.black, fontSize: 15, fontFamily: 'Hanuman'),
              ),
              onChanged: (String? value) {
                indexMonth = _listMonthKH.indexOf(value.toString());
                setState(() {
                  _choiceMonth = value.toString();
                  _dataList.clear();
                  _startDate =
                      DateTime(int.parse(_choiceYear), indexMonth + 1, 1);
                  _endDate =
                      DateTime(int.parse(_choiceYear), indexMonth + 2, 0);
                });
                _getDataFromNotes(_choiceType, _startDate, _endDate);
                DisplayChart(myDataList: _dataList, refresh: refresh);
              }, // setting hint
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('endYear', endYear));
  }
}

import 'dart:convert';
import 'dart:ffi';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import 'package:khmer_date/khmer_date.dart';
import 'package:table_calendar/table_calendar.dart';
import '../app_colors.dart';
import 'package:http/http.dart' as http;
import '../utils/utils.dart';
import 'update_transaction_screen.dart';

class TransationScreen extends StatefulWidget {
  const TransationScreen({super.key});

  @override
  State<TransationScreen> createState() => _TransationScreenState();
}

class _TransationScreenState extends State<TransationScreen> {
  String totalAmount = '0.0';
  String totalIncome = '0.0';
  String totalExpense = '0.0';

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  // DateTime? _selectedDay;

  late final ValueNotifier<List<Event>> _selectedEvents;
  String khr = '0';
  String _date = "";
  bool isLoading = true;
  final kToday = DateTime.now();
  final kFirstDay = DateTime(DateTime.now().day);
  final kLastDay = DateTime(DateTime.now().day);
  Iterable itemList = [];
  int messageCount = 0;
  Map<dynamic, dynamic> sumByType = {};
  Map<String, List<dynamic>> _groupedItems = {};
  DateTime now = DateTime.now();

  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var getMonthFormatter = DateFormat('MM');
  var getYearFormatter = DateFormat('yyyy');

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'April',
    'May',
    'Jun',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  int _selectedMonth = 10;
  int _selectedYear = 1993;

  @override
  void initState() {
    isLoading = false;
    _fetchExchangeRate();
    String month = getMonthFormatter.format(now);
    String year = getYearFormatter.format(now);
    _selectedMonth = int.parse(month);
    _selectedYear = int.parse(year);
    setState(() {
      startDate = DateTime(_selectedYear, _selectedMonth, 1);
      endDate = DateTime(_selectedYear, _selectedMonth + 1, 0);
      if (kDebugMode) {
        print('${startDate} ${endDate}');
      }
    });
    _getDataFromNotes(startDate, endDate);
    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _fetchExchangeRate() async {
    final response = await http.get(
      Uri.parse(
          'https://api.apilayer.com/exchangerates_data/convert?to=KHR&from=USD&amount=1'),
      headers: {
        'Content-Type': 'text/plain',
        'apikey': 'Q3Tst29OtGyrmDrH43kqbIXHOMGdQOR1',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      var result = jsonDecode(response.body);
      setState(() {
        khr = result['result'].toStringAsFixed(2).toString();
        _date = KhmerDate.date(DateTime.now().toIso8601String(),
            format: "ថ្ងៃdddd ទីdd ខែmmm ឆ្នាំyyyy");
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
    setState(() {
      isLoading = false;
    });
  }

  void _getDataFromNotes(DateTime start_date, DateTime end_date) {
    DatabaseReference starCountRef = FirebaseDatabase.instance
        .ref("users-${FirebaseAuth.instance.currentUser?.uid}");

    starCountRef.onValue.listen((DatabaseEvent event) {
      var snapshotValue = event.snapshot.value;

      if (snapshotValue != null && snapshotValue is Map) {
        setState(() {
          _groupedItems =
              _groupItemsByDate(snapshotValue, start_date, end_date);
          sumByType = _calculateSumByType(_groupedItems.values.toList());

          totalIncome = sumByType["ចំណូល"]?.toString() ?? '0.0';
          totalExpense = sumByType["ចំណាយ"]?.toString() ?? '0.0';

          totalAmount = (double.parse(totalIncome) - double.parse(totalExpense))
              .toStringAsFixed(2);
        });
      } else {
        if (kDebugMode) {
          print('itemList is not found');
        }
      }
    });
  }

  Map<String, List<dynamic>> _groupItemsByDate(
    Map<dynamic, dynamic> items,
    DateTime startDate,
    DateTime endDate,
  ) {
    Map<String, List<dynamic>> groupedItems = {};

    items.forEach((key, value) {
      String pickupDate = value['pickupDate'].toString();
      if (!groupedItems.containsKey(pickupDate)) {
        groupedItems[pickupDate] = [];
      }
      groupedItems[pickupDate]!.add(value);
    });

    // Filter items within the date range
    groupedItems.removeWhere((date, items) {
      DateTime currentDate = _parseDateString(date);
      return !(currentDate.isAfter(startDate) &&
              currentDate.isBefore(endDate)) &&
          !currentDate.isAtSameMomentAs(startDate) &&
          !currentDate.isAtSameMomentAs(endDate);
    });

    List<String> sortedDates = groupedItems.keys.toList()
      ..sort((a, b) {
        DateTime dateA = _parseDateString(a);
        DateTime dateB = _parseDateString(b);
        return dateB.compareTo(dateA);
      });
    Map<String, List<dynamic>> sortedJsonData = {};
    sortedDates.forEach((date) {
      sortedJsonData[date] = groupedItems[date]!;
    });
    return sortedJsonData;
  }

  DateTime _parseDateString(String dateString) {
    final format = DateFormat('dd-MMM-yyyy', 'en_US');
    return format.parse(dateString);
  }

  Map<String, double> _calculateSumByType(List<dynamic> itemList) {
    Map<String, double> sumByType = {};
    for (var group in itemList.toList()) {
      for (var item in group) {
        String itemType = item['type'];
        try {
          double itemAmount = double.parse(item['amount']);
          sumByType[itemType] = (sumByType[itemType] ?? 0) + itemAmount;
        } catch (e) {
          print("Error parsing amount for item: $item");
          // Handle the error as needed, for example:
          // log the error, skip the item, or assign a default value
        }
      }
    }
    return sumByType;
  }

  showAlertDialog(BuildContext context, String message, String heading,
      String buttonAcceptTitle, String buttonCancelTitle) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            surfaceTintColor: Colors.white,
            title: Text(
              heading,
              style: const TextStyle(
                fontFamily: 'Hanuman',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: formKey,
                autovalidateMode: _autovalidate,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownDatePicker(
                        locale: "en",
                        dateformatorder: OrderFormat.YDM, // default is myd
                        inputDecoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                            helperText: '',
                            contentPadding: const EdgeInsets.all(8),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(5))), // optional
                        isDropdownHideUnderline: true, // optional
                        isFormValidator: true, // optional
                        startYear: 1900, // optional
                        endYear: 2200, // optional
                        // width: 50, // optional
                        // selectedDay: _selectedDay, // optional
                        selectedMonth: _selectedMonth, // optional
                        selectedYear: _selectedYear, // optional
                        // onChangedDay: (value) {
                        //   _selectedDay = int.parse(value!);
                        //   print('onChangedDay: $value');
                        // },
                        onChangedMonth: (value) {
                          _selectedMonth = int.parse(value!);
                          print('onChangedMonth: $value');
                        },
                        onChangedYear: (value) {
                          _selectedYear = int.parse(value!);
                          print('onChangedYear: $value');
                        },
                        // boxDecoration: BoxDecoration(
                        // border: Border.all(color: Colors.grey, width: 1.0)), // optional
                        showDay: false, // optional
                        dayFlex: 2, // optional
                        // locale: "kh",// optional
                        // hintDay: 'Day', // optional
                        hintMonth: 'Month', // optional
                        hintYear: 'Year', // optional
                        hintTextStyle:
                            const TextStyle(color: Colors.grey), // optional
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            setState(() {
                              _selectedMonth = _selectedMonth;
                              _selectedYear = _selectedYear;
                              startDate =
                                  DateTime(_selectedYear, _selectedMonth, 1);
                              endDate = DateTime(
                                  _selectedYear, _selectedMonth + 1, 0);
                              _getDataFromNotes(startDate, endDate);
                            });
                            // DateTime? date = _dateTime(
                            //     _selectedDay, _selectedMonth, _selectedYear);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     action: SnackBarAction(
                            //       label: 'OK',
                            //       onPressed: () {},
                            //     ),
                            //     content: Text('selected date is $date'),
                            //     elevation: 20,
                            //   ),
                            // );
                          } else {
                            print('on error');
                            setState(() {
                              _autovalidate = AutovalidateMode.always;
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          buttonAcceptTitle,
                          style: const TextStyle(
                              fontFamily: 'Hanuman',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  showAlertDialogExchangeRate(
      BuildContext context, String heading, double size) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          surfaceTintColor: Colors.white,
          title: Text(
            '$heading $_date',
            style: const TextStyle(
              fontFamily: 'Hanuman',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: isLoading
              ? const CircularProgressIndicator() // Show CircularProgressIndicator while loading
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    khr == '0' ? Text(
                      'Coming soon...',
                      style: TextStyle(fontFamily: 'Hanuman'),
                    )
                    : TextButton.icon(
                      onPressed: () async {},
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey[100])),
                      icon: Image.asset(
                        "assets/images/icon/us_flag.png",
                        fit: BoxFit.contain,
                        height: 24,
                      ),
                      label: const Row(
                        children: [
                          Text(
                            "1 អាមេរិក (ដុល្លា)",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Hanuman',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {},
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.grey[100]),
                      ),
                      icon: Image.asset(
                        "assets/images/icon/kh_flag.png",
                        fit: BoxFit.contain,
                        height: 24,
                      ),
                      label: Row(
                        children: [
                          Text(
                            "$khr កម្ពុជា​ (រៀល)",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontFamily: 'Hanuman',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          surfaceTintColor: Colors.transparent,
          title: Container(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      _fetchExchangeRate();
                      showAlertDialogExchangeRate(
                          context, "អត្រាប្តូរប្រាក់​", size);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor: const MaterialStatePropertyAll(
                          Color.fromARGB(255, 249, 249, 249)),
                    ),
                    icon: Image.asset(
                      "assets/images/icon/web.png",
                      fit: BoxFit.contain,
                      height: 20,
                    ),
                    label: Row(
                      children: [
                        Text(
                          "lbExchange".tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Hanuman',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                  Text(
                    'lbTitle1'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Hanuman',
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  Container(
                    width: 100,
                  ),
                ],
              ),
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: hexToColor('#ffffff'), //bottom bar icons
          ),
        ),
        backgroundColor: AppColors.myColorBackground,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: _groupedItems.isEmpty
                      ? const EdgeInsets.symmetric(horizontal: 25)
                      : const EdgeInsets.symmetric(horizontal: 0),
                  height: 60.0,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (kDebugMode) {
                            print("clicked showAlertDialog()");
                          }
                          showAlertDialog(context, 'ជ្រើសរើស', "ជ្រើសរើស",
                              "យល់ព្រម", "បោះបង់");
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 0.0),
                          padding: const EdgeInsets.only(
                              top: 10, left: 0, right: 10),
                          child: Column(
                            children: [
                              Text(
                                _selectedYear.toString(),
                                style: const TextStyle(
                                    fontFamily: 'Hanuman',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              Row(
                                children: [
                                  Text(
                                    months[_selectedMonth - 1],
                                    style: const TextStyle(
                                        fontFamily: 'Hanuman',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  Container(
                                    margin: EdgeInsets.zero,
                                    child:
                                        const Icon(Icons.arrow_drop_down_sharp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 0.0),
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Image.asset(
                                    'assets/images/icon/income.png',
                                    width: 24,
                                  ),
                                ),
                                Text(
                                  'lbIncome'.tr(),
                                  style: TextStyle(
                                      fontFamily: 'Hanuman',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Text(
                              double.parse(totalIncome.toString()).toStringAsFixed(2),
                              style: const TextStyle(
                                  fontFamily: 'Hanuman',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // height: 100.0,
                        margin: const EdgeInsets.only(top: 0.0),
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 15),
                        // width: 150,
                        decoration: const BoxDecoration(
                          border: Border(
                              // left: BorderSide(
                              //   color: Colors.black,
                              //   width: 1.5
                              // ),
                              // right: BorderSide(
                              //   color: Colors.black,
                              //   width: 1.5
                              // ),
                              ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Image.asset(
                                    'assets/images/icon/expenses.png',
                                    width: 24,
                                  ),
                                ),
                                Text(
                                  'lbExpense'.tr(),
                                  style: TextStyle(
                                      fontFamily: 'Hanuman',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Text(
                              double.parse(totalExpense.toString()).toStringAsFixed(2),
                              style: const TextStyle(
                                  fontFamily: 'Hanuman',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // height: 100.0,
                        margin: const EdgeInsets.only(top: 0.0),
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 0),
                        // width: 150,
                        decoration: const BoxDecoration(
                            //   border: Border(
                            // left: BorderSide(
                            //   color: Colors.black,
                            //   width: 1.5
                            // ),
                            // right: BorderSide(
                            //   color: Colors.black,
                            //   width: 1.5
                            // ),
                            // ),
                            ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Image.asset(
                                    'assets/images/icon/wallet.png',
                                    width: 24,
                                  ),
                                ),
                                Text(
                                  'lbTotal'.tr(),
                                  style: TextStyle(
                                      fontFamily: 'Hanuman',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Text(
                              double.parse(totalAmount.toString()).toStringAsFixed(2),
                              style: const TextStyle(
                                  fontFamily: 'Hanuman',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: _groupedItems.isEmpty
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 4),
                        color: Colors.white,
                        child: Text(
                          'lbIntroAddTakeNote'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Hanuman',
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _groupedItems.length,
                        itemBuilder: (context, index) {
                          String date = _groupedItems.keys.elementAt(index);
                          List<dynamic> items = _groupedItems[date]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.grey[200], // Set background color
                                  borderRadius: BorderRadius.circular(
                                      3.0), // Set border radius
                                ), // Set background color
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Container(
                                    //   margin: const EdgeInsets.only(
                                    //       top: 5, left: 5, right: 5, bottom: 5),
                                    //   width: MediaQuery.of(context).size.width,
                                    //   child: Dash(
                                    //       direction: Axis.horizontal,
                                    //       length: size - 30,
                                    //       dashLength: 2,
                                    //       dashGap: 3,
                                    //       dashColor: Colors.grey,
                                    //       dashBorderRadius: 4,
                                    //       dashThickness: 2),
                                    // ),
                                    Text(
                                      '${'lbTransection'.tr()} $date',
                                      style: const TextStyle(
                                        fontFamily: 'Hanuman',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    // Container(
                                    //   margin: const EdgeInsets.only(
                                    //       top: 2, left: 5, right: 5, bottom: 5),
                                    //   width: MediaQuery.of(context).size.width,
                                    //   child: Dash(
                                    //       direction: Axis.horizontal,
                                    //       length: size - 30,
                                    //       dashLength: 2,
                                    //       dashGap: 3,
                                    //       dashColor: Colors.grey,
                                    //       dashBorderRadius: 4,
                                    //       dashThickness: 2),
                                    // ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (context, itemIndex) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateTransctionScreen(
                                                    id: items[itemIndex]['id']
                                                        .toString(),
                                                  )));
                                      if (kDebugMode) {
                                        print(
                                            ">>>>>>>>>>>>> Click item ${items[itemIndex]['id'].toString()}");
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 5,
                                                            right: 10,
                                                            bottom: 10),
                                                        child: Image.asset(
                                                          "assets/images/types/${items[itemIndex]['category']}.png",
                                                          width: 24,
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5,
                                                                      right: 5),
                                                              child: Text(
                                                                items[itemIndex]
                                                                        [
                                                                        'amount']
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontFamily:
                                                                        'Hanuman'),
                                                              ),
                                                            ),
                                                            Text(
                                                              items[itemIndex]['type'].toString() == "ចំណាយ" ? 'lbExpense'.tr() : 'lbIncome'.tr(),
                                                              style: TextStyle(
                                                                  color: items[itemIndex]['type'].toString() ==
                                                                          "ចំណាយ"
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .green,
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontFamily:
                                                                      'Hanuman'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.zero,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5,
                                                                  right: 5),
                                                          child: Text(
                                                            items[itemIndex][
                                                                    'pickupDate']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 10.0,
                                                                fontFamily:
                                                                    'Hanuman'),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5,
                                                                  right: 5),
                                                          child: Text(
                                                            items[itemIndex]
                                                                    ['remark']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 10.0,
                                                                fontFamily:
                                                                    'Hanuman'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 2,
                                                bottom: 5,
                                                left: 0,
                                                right: 0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Dash(
                                                direction: Axis.horizontal,
                                                length: (size / 2) + 120,
                                                dashLength: 2,
                                                dashGap: 2,
                                                dashColor: Colors.grey,
                                                dashBorderRadius: 10,
                                                dashThickness: 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime>('now', now));
  }
}

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../app_colors.dart';

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
  DateTime? _selectedDay;
  final kToday = DateTime.now();
  final kFirstDay = DateTime(DateTime.now().day);
  final kLastDay = DateTime(DateTime.now().day);
  Iterable itemList = [];
  int messageCount = 0;
  Map<dynamic, dynamic> sumByType = {};
  String labelFromDate = '';
  String labelToDate = '';
  Map<String, List<dynamic>> _groupedItems = {};

  @override
  void initState() {
    _getDataFromNotes();
    super.initState();
  }

  void _getDataFromNotes() {
    DatabaseReference starCountRef = FirebaseDatabase.instance
        .ref("users-${FirebaseAuth.instance.currentUser?.uid}");

    starCountRef.onValue.listen((DatabaseEvent event) {
      var snapshotValue = event.snapshot.value;

      if (snapshotValue != null && snapshotValue is Map) {
        setState(() {
          itemList = _sortItems(snapshotValue);
          _groupedItems = _groupItemsByDate(snapshotValue);
          // print('_groupedItems $_groupedItems');
          labelFromDate = itemList.first['pickupDate'].toString();
          labelToDate = itemList.last['pickupDate'].toString();
          sumByType = _calculateSumByType(itemList.toList());

          totalIncome = sumByType["ចំណូល"]?.toString() ?? '0.0';
          totalExpense = sumByType["ចំណាយ"]?.toString() ?? '0.0';

          double income = sumByType["ចំណូល"] ?? 0.0;
          double expenses = sumByType["ចំណាយ"] ?? 0.0;
          totalAmount = (income - expenses).toString();
        });
      } else {
        if (kDebugMode) {
          print('itemList is not found');
        }
      }
    });
  }

  Map<String, List<dynamic>> _groupItemsByDate(Map<dynamic, dynamic> items) {
    Map<String, List<dynamic>> groupedItems = {};

    items.forEach((key, value) {
      String pickupDate = value['pickupDate'].toString();
      if (!groupedItems.containsKey(pickupDate)) {
        groupedItems[pickupDate] = [];
      }
      groupedItems[pickupDate]!.add(value);
    });

    if (kDebugMode) {
      print('groupedItems $groupedItems');
    }

    // Sort the keys (dates)
    List<String> sortedDates = groupedItems.keys.toList()
      ..sort((a, b) {
        DateTime dateA = _parseDateString(a);
        DateTime dateB = _parseDateString(b);
        return dateB.compareTo(dateA);
      });

    // Reconstruct the sorted JSON data
    Map<String, List<dynamic>> sortedJsonData = {};
    sortedDates.forEach((date) {
      sortedJsonData[date] = groupedItems[date]!;
    });

    if (kDebugMode) {
      print('sortedJsonData $sortedJsonData');
    }
    return sortedJsonData;
  }

  List<dynamic> _sortItems(Map<dynamic, dynamic> snapshotValue) {
    List<dynamic> userList = snapshotValue.values.toList();

    userList.sort((a, b) {
      var dateA = _parseDateString(a['pickupDate'].toString());
      var dateB = _parseDateString(b['pickupDate'].toString());
      return dateA.compareTo(dateB);
    });

    return userList;
  }

  DateTime _parseDateString(String dateString) {
    final format = DateFormat('dd-MMM-yyyy', 'en_US');
    return format.parse(dateString);
  }

  Map<String, double> _calculateSumByType(List<dynamic> itemList) {
    Map<String, double> sumByType = {};

    for (var transaction in itemList) {
      var type = transaction["type"];
      var amount = double.tryParse(transaction["amount"].toString());

      if (type != null && amount != null) {
        sumByType.update(type, (value) => value + amount,
            ifAbsent: () => amount);
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
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 355,
            child: TableCalendar(
              locale: 'KM',
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              weekNumbersVisible: false,
              rowHeight: 45.0,
              daysOfWeekHeight: 20.0,
              formatAnimationCurve: Curves.easeOutSine,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: true,
                markerDecoration: BoxDecoration(
                    color: Color(0xFF263238), shape: BoxShape.rectangle),
                todayTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
                todayDecoration: BoxDecoration(
                    color: Colors.green, shape: BoxShape.rectangle),
                holidayTextStyle:
                    TextStyle(color: Color.fromARGB(255, 192, 122, 92)),
                holidayDecoration: BoxDecoration(
                    border: Border.fromBorderSide(
                        BorderSide(color: Color(0xFF9FA8DA), width: 1.4)),
                    shape: BoxShape.circle),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontFamily: 'Hanuman',
                    fontSize: 15,
                  ),
                  weekendStyle: TextStyle(
                      fontFamily: 'Hanuman', fontSize: 15, color: Colors.red)),
              dayHitTestBehavior: HitTestBehavior.translucent,
              // focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 0, right: 15),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        buttonAcceptTitle,
                        style: const TextStyle(
                            fontFamily: 'Hanuman',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      // true here means you clicked ok
                    },
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Text(
                      buttonCancelTitle,
                      style: const TextStyle(
                          fontFamily: 'Hanuman',
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    // true here means you clicked ok
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
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
            heading,
            style: const TextStyle(
              fontFamily: 'Hanuman',
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () async {},
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        "1 ដុល្លា",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Hanuman',
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_right),
                TextButton.icon(
                  onPressed: () async {},
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey[100])),
                  icon: Image.asset(
                    "assets/images/icon/kh_flag.png",
                    fit: BoxFit.contain,
                    height: 24,
                  ),
                  label: const Row(
                    children: [
                      Text(
                        "4000 រៀល",
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
          title: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      showAlertDialogExchangeRate(
                          context, "អត្រាប្តូរប្រាក់", size);
                      print("weSlide ...............");
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                        backgroundColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 249, 249, 249))),
                    icon: Image.asset(
                      "assets/images/icon/web.png",
                      fit: BoxFit.contain,
                      height: 20,
                    ),
                    label: const Row(
                      children: [
                        Text(
                          "អត្រា",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Hanuman',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                  Container(
                    child: const Text(
                      'ប្រតិបត្តិការ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Hanuman',
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      print("weSlide ...............");
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.white)),
                    icon: Image.asset(
                      "assets/images/icon/web.png",
                      fit: BoxFit.contain,
                      height: 20,
                    ),
                    label: const Row(
                      children: [
                        Text(
                          "អត្រា",
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
              Container(
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
                        padding:
                            const EdgeInsets.only(top: 10, left: 0, right: 10),
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
                            const Text(
                              '2024',
                              style: TextStyle(
                                  fontFamily: 'Hanuman',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Apr',
                                  style: TextStyle(
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
                                  'assets/images/icon/income.png',
                                  width: 24,
                                ),
                              ),
                              const Text(
                                'ចំណូល',
                                style: TextStyle(
                                    fontFamily: 'Hanuman',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            totalIncome.toString(),
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
                              const Text(
                                'ចំណាយ',
                                style: TextStyle(
                                    fontFamily: 'Hanuman',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            totalExpense.toString(),
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
                              const Text(
                                'សរុប',
                                style: TextStyle(
                                    fontFamily: 'Hanuman',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            totalAmount.toString(),
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
              Flexible(
                child: ListView.builder(
                  itemCount: _groupedItems.length,
                  itemBuilder: (context, index) {
                    String date = _groupedItems.keys.elementAt(index);
                    List<dynamic> items = _groupedItems[date]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 5, left: 5, right: 5, bottom: 5),
                          width: MediaQuery.of(context).size.width,
                          child: Dash(
                              direction: Axis.horizontal,
                              length: size - 30,
                              dashLength: 2,
                              dashGap: 3,
                              dashColor: Colors.grey,
                              dashBorderRadius: 4,
                              dashThickness: 2),
                        ),
                        Text(
                          ' បញ្ជីប្រតិបត្តិការ: $date',
                          style: TextStyle(
                            fontFamily: 'Hanuman',
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 2, left: 5, right: 5),
                          width: MediaQuery.of(context).size.width,
                          child: Dash(
                              direction: Axis.horizontal,
                              length: size - 30,
                              dashLength: 2,
                              dashGap: 3,
                              dashColor: Colors.grey,
                              dashBorderRadius: 4,
                              dashThickness: 2),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, itemIndex) {
                            // Customize the item UI as per your requirement
                            return GestureDetector(
                              onTap: () {
                                if (kDebugMode) {
                                  print(
                                      "Click item ${items[itemIndex]['amount'].toString()}");
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.zero,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  margin: const EdgeInsets.only(
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
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 5, right: 5),
                                                        child: Text(
                                                          items[itemIndex]
                                                                  ['amount']
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontFamily:
                                                                  'Hanuman'),
                                                        ),
                                                      ),
                                                      Text(
                                                        items[itemIndex]['type']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: items[itemIndex]
                                                                            [
                                                                            'type']
                                                                        .toString() ==
                                                                    "ចំណាយ"
                                                                ? Colors.red
                                                                : Colors.green,
                                                            fontSize: 12.0,
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
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: Text(
                                                      items[itemIndex]
                                                              ['pickupDate']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 10.0,
                                                          fontFamily:
                                                              'Hanuman'),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: Text(
                                                      items[itemIndex]['remark']
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
                                          bottom: 10,
                                          left: 5,
                                          right: 5),
                                      width: MediaQuery.of(context).size.width,
                                      child: Dash(
                                          direction: Axis.horizontal,
                                          length: size - 30,
                                          dashLength: 2,
                                          dashGap: 3,
                                          dashColor: Colors.grey,
                                          dashBorderRadius: 4,
                                          dashThickness: 2),
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
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool val = false;
  Color kSecondaryColor = const Color.fromARGB(255, 250, 182, 55);

  Map<String, double> dataMap = {
    "Groceries": 50.0,
    'Gas': 30.0,
    'Utilities': 100.0,
    'Dining Out': 40.0,
    'Entertainment': 20.0,
    'Transportation': 25,
    'Clothing': 60.0,
  };

  static const Map<String, String> legendLabels = {
    "Groceries": "Groceries",
    'Gas': "Gas",
    'Utilities': "Utilities",
    'Dining Out': 'Dining Out',
    'Entertainment': 'Entertainment',
    'Transportation': 'Transportation',
    'Clothing': 'Clothing',
  };

  List<String> expenses = [
    "Groceries",
    'Gas',
    'Utilities',
    'Dining Out',
    'Entertainment',
    'Transportation',
    'Clothing',
  ];

  int selectKhmerMonth = 0;
  List<String> khmerMonths = [
    "មករា", // January
    "កុម្ភៈ", // February
    "មិនា", // March
    "មេសា", // April
    "ឧសភា", // May
    "មិថុនា", // June
    "កក្កដា", // July
    "សីហា", // August
    "កញ្ញា", // September
    "តុលា", // October
    "វិច្ឆិកា", // November
    "ធ្នូ" // December
  ];

  void nextMonth() {
  setState(() {
    selectKhmerMonth = selectKhmerMonth >= 11 ? 0 : selectKhmerMonth + 1;
  });
}

  void previousMonth() {
  setState(() {
    selectKhmerMonth = selectKhmerMonth <= 0 ? 0 : selectKhmerMonth - 1;
  });
}

  final List<Color> colorList = generateColors(20);

  static List<Color> generateColors(int numberOfColors) {
    Random random = Random();
    List<Color> generatedColors = [];
    for (int i = 0; i <= numberOfColors; i++) {
      generatedColors.add(
        Color.fromRGBO(
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          1,
        ),
      );
    }
    return generatedColors;
  }

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorTittle,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'ប្រតិបត្តិការ',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Hanuman',
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: AppColors.myColorBlack),
        ),
      ),
      backgroundColor: AppColors.myColorBackground,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.myColorTittle,
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print(" onTap arrow_back_ios");
                        setState(() {
                          previousMonth();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 20.0),
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    Text(
                      khmerMonths[selectKhmerMonth],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Hanuman',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.myColorBlack),
                    ),
                    GestureDetector(
                      onTap: () {
                        nextMonth();

                        print(" onTap arrow_forward_ios_rounded");
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 20.0),
                        child: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(top: 0, left: 25.0, right: 25.0),
                child: ToggleSwitch(
                  animate: true,
                  animationDuration: 50,
                  minWidth: double.infinity,
                  minHeight: 45,
                  cornerRadius: 50.0,
                  activeBgColors: [
                    const [Colors.green],
                    [Colors.red[800]!]
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: const Color.fromARGB(255, 200, 200, 200),
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: 0,
                  totalSwitches: 2,
                  labels: const ['ចំណូល', 'ចំណាយ'],
                  customTextStyles: const [TextStyle(fontSize: 17)],
                  radiusStyle: true,
                  onToggle: (index) {
                    print('switched to: $index');
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                child: const Text(
                  "សិត្តិប្រតិបត្តិការ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Hanuman',
                      fontSize: 16,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: PieChart(
                  dataMap: dataMap,
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 40,
                  chartRadius: MediaQuery.of(context).size.width / 2.5,
                  colorList: colorList,
                  initialAngleInDegree: 1.0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 42,
                  centerText: "",
                  legendLabels: legendLabels,
                  legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      showLegends: true,
                      legendPosition: LegendPosition.right,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      legendLabels: legendLabels),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValues: false,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                    decimalPlaces: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                height: double.parse(expenses.length.toString()) * 90,
                child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataMap.length, // The total number of items
                  itemBuilder: (BuildContext context, int index) {
                    String key = dataMap.keys.elementAt(index);
                    double value = dataMap.values.elementAt(index);
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color:
                              colorList[index], // Your desired background color
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15),
                          ]),
                      child: ListTile(
                        leading: const Icon(Icons.flight_land),
                        tileColor: Colors.black.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          key,
                          style: TextStyle(
                            fontSize: 16,
                            color: kSecondaryColor,
                          ),
                        ),
                        subtitle: Text(
                          "$value%",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.myColorGrey_3,
                          ),
                        ),
                      ),
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

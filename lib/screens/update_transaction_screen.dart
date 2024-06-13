import 'dart:async';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:decorated_dropdownbutton/decorated_dropdownbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../app_colors.dart';
import 'main_screen.dart';

class UpdateTransctionScreen extends StatefulWidget {
  final String id;
  const UpdateTransctionScreen({super.key, required this.id});

  @override
  State<UpdateTransctionScreen> createState() => _UpdateTransctionScreenState();
}

class _UpdateTransctionScreenState extends State<UpdateTransctionScreen> {
  Map<String, dynamic> newData = {};

  bool val = false;
  late int _tabTextIndexSelected = 0;
  final List<String> _listTextTabToggle = ["ចំណូល", "ចំណាយ"];
  final String info = "កែប្រែពត័មានឱ្យបានត្រឹមត្រូវ \nឬក៏ចង់លុបព័ត៍មាន!";
  Color red = Colors.red[800]!;
  Color green = Colors.green;
  String pickupDate = "";
  final FocusNode _focusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _pickUpDateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String type = '';
  String amount = '';
  String category = 'other';
  String remark = '';
  final controller = BoardDateTimeController();
  DateTime date = DateTime.now();

  final List<Map<String, dynamic>> myItems = [
    {
      "value": "other",
      "name": "ផ្សេងៗ",
      "icon": "other",
    },
    {
      "value": "education",
      "name": "អប់រំ",
      "icon": "education",
    },
    {
      "value": "food",
      "name": "អាហារ",
      "icon": "food",
    },
    {
      "value": "gasoline",
      "name": "ប្រេងឥន្ទនៈ",
      "icon": "gasoline",
    },
    {
      "value": "motorcycle",
      "name": "ម៉ូតូ",
      "icon": "motorcycle",
    },
    {
      "value": "car",
      "name": "ឡាន",
      "icon": "car",
    },
    {
      "value": "health",
      "name": "សុខភាព",
      "icon": "health",
    },
    {
      "value": "home",
      "name": "ផ្ទះ",
      "icon": "home",
    },
    {
      "value": "shopping",
      "name": "ទិញទំនិញ",
      "icon": "shopping",
    },
    {
      "value": "spot",
      "name": "កីឡា",
      "icon": "spot",
    },
    {
      "value": "work",
      "name": "ការងារ",
      "icon": "work",
    },
    {
      "value": "trip",
      "name": "កាធ្វើដំណើរ",
      "icon": "trip",
    }
  ];

  @override
  void initState() {
    fetchRecord(widget.id);
    super.initState();
  }

  fetchRecord(String recordId) {
    DatabaseReference starCountRef = FirebaseDatabase.instance
        .ref("users-${FirebaseAuth.instance.currentUser?.uid}");

    starCountRef.child(recordId).onValue.listen((DatabaseEvent event) {
      var snapshotValue = event.snapshot.value;

      if (snapshotValue != null && snapshotValue is Map) {
        setState(() {
          _amountController.text = snapshotValue['amount'].toString();
          category = snapshotValue['category'].toString();
          _tabTextIndexSelected =
              (snapshotValue['type'].toString() == "ចំណូល" ? 0 : 1);
          _typeController.text = _listTextTabToggle[_tabTextIndexSelected];
          pickupDate = snapshotValue['pickupDate'].toString();
          _remarkController.text = snapshotValue['remark'].toString();
        });
      }
    });
  }

  void updateRecord(String recordId, Map<String, dynamic> _newData) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref("users-${FirebaseAuth.instance.currentUser?.uid}");

    print('newData $_newData');
    databaseReference.child(recordId).once().then((snapshot) {
      if (snapshot.snapshot.value != null) {
        // Update the record with new data
        databaseReference.child(recordId).update(_newData);
        print('Record updated successfully');
        Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const MainScreen(index: 0),
            ),
            (route) => false);
      } else {
        print('Record not found');
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  deleteRecord(String recordId) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref("users-${FirebaseAuth.instance.currentUser?.uid}");

    // Reference the specific record by its ID and remove it
    databaseReference.child(recordId).remove().then((_) {
      print("Record $recordId deleted successfully");
      Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const MainScreen(index: 0),
          ),
          (route) => false);
    }).catchError((error) {
      print("Error deleting record: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorBackground,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "ព័ត៍មានលម្អិត",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Hanuman',
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: hexToColor('#f2f2ff'), //bottom bar icons
        ),
      ),
      backgroundColor: AppColors.myColorBackground,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Form(
            key: _formKey, // Associate the form key with this Form widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    info,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'Hanuman',
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        letterSpacing: 0,
                        wordSpacing: 0,
                        color: AppColors.myColorBlack),
                  ),
                ),
                ToggleSwitch(
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
                  initialLabelIndex: _tabTextIndexSelected,
                  totalSwitches: 2,
                  labels: _listTextTabToggle,
                  customTextStyles: const [TextStyle(fontSize: 17)],
                  radiusStyle: true,
                  onToggle: (index) {
                    setState(() {
                      _tabTextIndexSelected = index!;
                      _typeController.text =
                          _listTextTabToggle[_tabTextIndexSelected];
                      type = _listTextTabToggle[_tabTextIndexSelected];
                    });
                    print('switched to: $type');
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(_focusNode);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // specify your color here
                          width: 1.5, // specify your width here
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 0),
                          child: Text(
                            _tabTextIndexSelected == 1 ? "- \$" : "+ \$",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Hanuman',
                                color: _tabTextIndexSelected == 1 ? red : green,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        IntrinsicWidth(
                          child: TextFormField(
                            controller: _amountController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            autofocus: true,
                            focusNode: _focusNode,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Hanuman',
                                color: _tabTextIndexSelected == 1 ? red : green,
                                fontWeight: FontWeight.normal),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                amount = value!;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: '0',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              hintStyle: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Hanuman',
                                  color:
                                      _tabTextIndexSelected == 1 ? red : green,
                                  fontWeight: FontWeight.bold),
                            ),
                            autocorrect: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: DecoratedDropdownButton(
                    value: category,
                    items: myItems.map((data) {
                      return DropdownMenuItem<String>(
                        value: data['value'].toString(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/types/${data['icon']}.png",
                              width: 24,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                data['name'],
                                style: const TextStyle(
                                  fontFamily: 'Hanuman',
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        category = value.toString();
                      });
                    },
                    color: Colors.grey[200], //background color
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 0), //border
                    borderRadius: BorderRadius.circular(3), //border radius
                    style: const TextStyle(
                        //text style
                        color: Colors.black,
                        fontSize: 15),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ), //icon
                    iconEnableColor: Colors.white, //icon enable color
                    dropdownColor: Colors.white, //dropdown background color
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(_focusNode);
                    final result = await showBoardDateTimePicker(
                      context: context,
                      pickerType: DateTimePickerType.date,
                      initialDate: DateTime.now(),
                      radius: 15,
                      options: BoardDateTimeOptions(
                        textColor: Colors.black,
                        foregroundColor: Colors.green[200],
                        activeTextColor: Colors.white,
                        backgroundColor: Colors.green,
                        activeColor: Colors.green,
                        boardTitle: "ជ្រើសរើសកាលបរិច្ឆេទ",
                        boardTitleTextStyle: const TextStyle(
                            fontFamily: 'Hanuman', fontSize: 16),
                        languages: const BoardPickerLanguages(
                          locale: 'km',
                          today: 'ថ្ងៃនេះ',
                          tomorrow: 'ថ្ងៃស្អែក',
                          now: 'ឥឡូវ',
                        ),
                        showDateButton: false,
                        backgroundDecoration: BoxDecoration(
                          backgroundBlendMode: BlendMode.screen,
                          color: Colors.green[100],
                          shape: BoxShape.rectangle,
                        ),
                        pickerSubTitles: const BoardDateTimeItemTitles(
                            year: "ឆ្នាំ",
                            month: "ខែ",
                            day: "ថ្ងៃ",
                            hour: "ម៉ោង",
                            minute: 'នាទី'),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        pickupDate =
                            BoardDateFormat('dd-MMM-yyyy').format(result);
                        _pickUpDateController.text = pickupDate;
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(3)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/icon/calendar.png",
                            width: 22,
                          ),
                          Text(
                            "  $pickupDate",
                            style: const TextStyle(
                                fontFamily: 'Hanuman', fontSize: 15),
                          )
                        ]),
                  ),
                ),
                Container(
                  height: 50,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.symmetric(vertical: 0.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(3)),
                  child: TextFormField(
                    controller: _remarkController,
                    cursorColor: AppColors.myColorGrey_3,
                    style: const TextStyle(fontFamily: 'Hanuman', fontSize: 16),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'ការកំណត់ចំណាំរបស់អ្នក',
                        hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                            fontFamily: 'Hanuman'),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 10),
                          child: Image.asset(
                            "assets/images/icon/note.png",
                            width: 1,
                            scale: 1,
                          ), // _myIcon is a 48px-wide widget.
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        remark = value!;
                      });
                    },
                    onTap: () {
                      if (kDebugMode) {
                        print('onTap');
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 50),
                      height: 50.0,
                       width: screenWidth * 0.3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                            side:
                                BorderSide(color: red), // Set border color here
                          ),
                        ),
                        onPressed: () async {
                          deleteRecord(widget.id);
                        },
                        child: const Text(
                          'លុប',
                          style: TextStyle(
                            fontFamily: 'Hanuman',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 30, bottom: 50),
                      height: 50.0,
                      width: screenWidth * 0.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                            side: BorderSide(
                                color: green), // Set border color here
                          ),
                        ),
                        onPressed: () async {
                          if (_amountController.text.isNotEmpty) {
                            newData = {
                              'amount': _amountController.text,
                              'pickupDate': pickupDate.toString(),
                              'remark': _remarkController.text,
                              'category': category.toString(),
                              'type': _typeController.text
                            };

                            updateRecord(widget.id, newData);
                          }
                        },
                        child: const Text(
                          'រក្សាទុក',
                          style: TextStyle(
                            fontFamily: 'Hanuman',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

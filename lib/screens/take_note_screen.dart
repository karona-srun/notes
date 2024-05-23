import 'package:beautiful_alert_dialog/beautiful_alert_dialog.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:decorated_dropdownbutton/decorated_dropdownbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../app_colors.dart';

class TakeNoteScreen extends StatefulWidget {
  const TakeNoteScreen({super.key});

  @override
  State<TakeNoteScreen> createState() => _TakeNoteScreenState();
}

class _TakeNoteScreenState extends State<TakeNoteScreen> {
  bool val = false;
  late int _tabTextIndexSelected = 0;
  final List<String> _listTextTabToggle = ["ចំណូល", "ចំណាយ"];
  final String info = "បញ្ជូលពត័មានឱ្យបានត្រឹមត្រូវ \nទើបរក្សាទុកបាន។";
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

  void _showDialog(BuildContext context, String title, String msg, int status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0), // Set border radius
          ),
          title: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  "assets/images/icon/icons8-${status == 1 ? 'done' : 'error'}.gif",
                  width: 32,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Hanuman',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          ),
          content: Text(msg,
              style: const TextStyle(fontFamily: 'Hanuman', fontSize: 16)),
          actions: <Widget>[
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red, // Set background color
                borderRadius: BorderRadius.circular(5.0), // Set border radius
              ),
              child: TextButton(
                child: const Text(
                  "បិទ",
                  style: TextStyle(
                      fontFamily: 'Hanuman', fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _validateForm(String parType, String parAmount, String parCategory,
      String parPickupDate, String parRemark) async {
    try {
      setState(() {
        parType = parType;
        parAmount = parAmount;
        parCategory = parCategory;
        parPickupDate = parPickupDate;
        parRemark = parRemark;
      });
      DatabaseReference ref = FirebaseDatabase.instance
          .ref("users-${FirebaseAuth.instance.currentUser?.uid}");
      DatabaseReference newPostRef = ref.push();
      String newRecordKey = newPostRef.key.toString();
      newPostRef.set({
        "id": newRecordKey,
        "type": parType,
        "amount": parAmount,
        "category": parCategory,
        "pickupDate": parPickupDate,
        "remark": parRemark,
      });
      ref.child(newRecordKey).set(newPostRef);
      debugPrint('Saved is success');
      setState(() {
        type = "";
        amount = "0";
        _amountController.clear();
        category = "other";
        pickupDate = pickupDate;
        remark = "";
      });
    } catch (error) {
      print("Error saving data: $error");
    }
  }

  final FocusNode _focus = FocusNode(); // 1) init _focus
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    setState(() {
      _tabTextIndexSelected = 0;
      val = false;
      _typeController.text = _listTextTabToggle[_tabTextIndexSelected];
      _amountController.clear();
      DateFormat.yMMMMd('en').format(DateTime.now());
      pickupDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorTittle,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'កត់ត្រា',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Hanuman',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.myColorBlack),
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
                                const TextInputType.numberWithOptions(decimal: true),
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
                        activeTextColor: Colors.white,
                        activeColor: Colors.green,
                        backgroundColor: Colors.white,
                        boardTitle: "ជ្រើសរើសកាលបរិច្ឆេទ",
                        boardTitleTextStyle: TextStyle(
                            fontFamily: 'Hanuman', fontSize: 16),
                        languages: BoardPickerLanguages(
                          locale: 'km',
                          today: 'ថ្ងៃនេះ',
                          tomorrow: 'ថ្ងៃស្អែក',
                          now: 'ឥឡូវ',
                        ),
                        showDateButton: false,
                        backgroundDecoration: BoxDecoration(
                          backgroundBlendMode: BlendMode.plus,
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                        ),
                        pickerSubTitles: BoardDateTimeItemTitles(
                            year: "ឆ្នាំ",
                            month: "ខែ",
                            day: "ថ្ងៃ",
                            hour: "ម៉ោង",
                            minute: 'នាទី'),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        pickupDate = BoardDateFormat('dd-MMM-yyyy').format(result);
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
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 50),
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _tabTextIndexSelected == 1 ? red : green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                        side: BorderSide(
                            color: _tabTextIndexSelected == 1
                                ? red
                                : green), // Set border color here
                      ),
                    ),
                    onPressed: () async {
                      if (_amountController.text.isNotEmpty) {
                        debugPrint('Start saveData ${_amountController.text}');
                        _validateForm(
                            _typeController.text,
                            _amountController.text,
                            category,
                            pickupDate,
                            _remarkController.text);
                        print('Form is valid');
                        _showDialog(context, 'ជោគជ័យ',
                            'ព័ត៍មានរបស់អ្នកត្រូវបានរក្សាដោយជោគជ័យ', 1);
                      } else {
                        // Form is not valid, do something
                        print('Form is not valid');
                        _showDialog(context, 'សារជូនដំណឹង',
                            'សួមបញ្ចូលព័ត៍មានឲ្យបានត្រឹមត្រូវ!', 2);
                      }
                      debugPrint('End saveData');
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
          ),
        ),
      ),
    );
  }
}

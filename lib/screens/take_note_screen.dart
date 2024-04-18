import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // A key for managing the form
  final String _name = '';
  String _email = '';

  final controller = BoardDateTimeController();
  DateTime date = DateTime.now();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Name: $_name');
      print('Email: $_email');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      pickupDate =
          BoardDateFormat('dd-MMM-yyyy hh:mm a').format(DateTime.now());
    });
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
                    });
                    print('switched to: $index');
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
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            autofocus: true,
                            focusNode: _focusNode,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Hanuman',
                                color: _tabTextIndexSelected == 1 ? red : green,
                                fontWeight: FontWeight.normal),
                            keyboardType: TextInputType.name,
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
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 0.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '',
                      hintText: 'ការកំណត់ចំណាំរបស់អ្នក',
                      prefixIcon: const Icon(Icons.folder),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _tabTextIndexSelected == 1 ? red : green,
                        ),
                      ),
                    ), // Label for the email field
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!; // Save the entered email
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(_focusNode);
                    final result = await showBoardDateTimePicker(
                      context: context,
                      pickerType: DateTimePickerType.datetime,
                      initialDate: DateTime.now(),
                      radius: 10,
                      options: const BoardDateTimeOptions(
                        backgroundColor: Colors.green,
                        boardTitle: "ជ្រើសរើសកាលបរិច្ឆេទ",
                        languages: BoardPickerLanguages(
                          locale: 'km',
                          today: 'ថ្ងៃនេះ',
                          tomorrow: 'ថ្ងៃស្អែក',
                          now: 'ឥឡូវ',
                        ),
                        showDateButton: true,
                        backgroundDecoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        pickerSubTitles: BoardDateTimeItemTitles(
                            year: "ឆ្នាំ",
                            month: "ខែ",
                            day: "ថ្ងៃ",
                            hour: "ម៉ោង",
                            minute: 'នាទី'),
                        activeColor: Colors.green,
                      ),
                    );
                    if (result != null) {
                      setState(() => pickupDate =
                          BoardDateFormat('dd-MMM-yyyy hh:mm a')
                              .format(result));
                    }
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // specify your color here
                          width: 1.5, // specify your width here
                        ),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.date_range),
                          Text(
                            "   $pickupDate",
                            style: const TextStyle(fontSize: 15),
                          )
                        ]),
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 0.0),
                  child: TextFormField(
                    cursorColor: AppColors.myColorGrey_3,
                    decoration: InputDecoration(
                      labelText: '',
                      hintText: 'ការកំណត់ចំណាំរបស់អ្នក',
                      prefixIcon: const Icon(Icons.notes_sharp),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _tabTextIndexSelected == 1 ? red : green,
                        ),
                      ),
                    ),
                    onSaved: (value) {
                      _email = value!;
                    },
                    onTap: () => {print('onTap')},
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40, bottom: 50),
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _tabTextIndexSelected == 1 ? red : green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: _tabTextIndexSelected == 1
                                ? red
                                : green), // Set border color here
                      ),
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'រក្សាទុក',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
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

import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'take_note_screen.dart';
import 'transation_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController = PageController();
  int _currentIndex = 0;
  bool keyboardOpen = false;
  final List<Widget> _tabs = [
    // const HomeScreen(),
    const TransationScreen(),
    const TakeNoteScreen(),
    const ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.myColorTittle,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          // FocusScope.of(context).requestFocus(FocusNode());
          // FocusManager.instance.primaryFocus?.unfocus();
        },
        child: PageView(controller: pageController, children: <Widget>[
          _tabs[_currentIndex],
        ]),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Visibility(
      //   visible: !keyboardIsOpen,
      //   child: Container(
      //     margin: const EdgeInsets.only(top: 0),
      //     width: 60,
      //     height: 60,
      //     child: FloatingActionButton(
      //       backgroundColor: Colors.orange,
      //       splashColor: Colors.orange,
      //       onPressed: () {
      //         setState(() {
      //           _currentIndex = 1;
      //         });
      //       },
      //       elevation: 0,
      //       shape: RoundedRectangleBorder(
      //           side: const BorderSide(width: 2, color: Colors.orange),
      //           borderRadius: BorderRadius.circular(100)),
      //       child: const Icon(
      //         Icons.add,
      //         color: Colors.white,
      //         size: 32,
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: AppColors.myColorActiveIcon,
        backgroundColor: AppColors.myColorTittle,
        unselectedItemColor: AppColors.myColorIcon,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Hanuman',
          color: AppColors.myColorIcon,
          fontWeight: FontWeight.w500,
        ),
        selectedLabelStyle: TextStyle(
          fontFamily: 'Hanuman',
          color: AppColors.myColorActiveIcon,
          fontWeight: FontWeight.w500,
        ),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 0),
            curve: Curves.ease,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/icon/notes_outline.png',
                color: AppColors.myColorIcon,
                width: 24,
                height: 24,
                fit: BoxFit.cover),
            activeIcon: Image.asset('assets/images/icon/notes.png',
                color: AppColors.myColorActiveIcon,
                width: 24,
                height: 24,
                fit: BoxFit.cover),
            label: 'ប្រតិបត្តិការ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: AppColors.myColorIcon,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.add,
              color: AppColors.myColorActiveIcon,
              size: 24,
            ),
            label: 'កត់ត្រា',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/icon/menu.png',
                color: AppColors.myColorIcon,
                width: 24,
                height: 24,
                fit: BoxFit.cover),
            activeIcon: Image.asset('assets/images/icon/menu_fill.png',
                color: AppColors.myColorActiveIcon,
                width: 24,
                height: 24,
                fit: BoxFit.cover),
            label: 'ផ្សេងទៀត',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
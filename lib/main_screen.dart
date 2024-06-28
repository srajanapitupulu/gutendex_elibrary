import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gutendex_elibrary/helpers/constants/colors.dart';
import 'package:gutendex_elibrary/pages/history_screen.dart';
import 'package:gutendex_elibrary/pages/home_screen.dart';
import 'package:gutendex_elibrary/pages/liked_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  double appBarHeight = 75.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _widgetOptions() {
    List<Widget> listOfWidgets = <Widget>[];

    listOfWidgets = <Widget>[
      const HomeScreen(),
      const LikedScreen(),
      const HistoryScreen()
    ];

    return listOfWidgets;
  }

  List<BottomNavigationBarItem> _bottomNavigationItems() {
    List<BottomNavigationBarItem> navBarItems = <BottomNavigationBarItem>[];

    navBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        label: "",
        icon: ImageIcon(
          AssetImage("assets/icons/ic_home.png"),
        ),
      ),
      const BottomNavigationBarItem(
        label: "",
        icon: ImageIcon(
          AssetImage("assets/icons/ic_like.png"),
        ),
      ),
      const BottomNavigationBarItem(
        label: "",
        icon: ImageIcon(
          AssetImage("assets/icons/ic_history.png"),
        ),
      ),
    ];

    return navBarItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: _widgetOptions().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: _bottomNavigationItems(),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: whiteBGColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkGrayColor,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

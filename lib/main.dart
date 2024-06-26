import 'package:flutter/material.dart';
import 'package:gutendex_elibrary/helpers/constants/colors.dart';
import 'package:gutendex_elibrary/models/book.dart';
import 'package:gutendex_elibrary/models/search_history.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gutendex_elibrary/splash_screen.dart';
import 'package:showcaseview/showcaseview.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(SearchHistoryAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onStart: (index, key) {},
      onComplete: (index, key) {},
      blurValue: 1,
      builder: Builder(
        builder: (context) {
          return MaterialApp(
            theme: ThemeData(
              fontFamily: 'JosefinSans',
              brightness: Brightness.light,
              primaryColor: blackColor,
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: SplashScreen.routeName,
            routes: <String, WidgetBuilder>{
              SplashScreen.routeName: (context) => const SplashScreen(),
            },
          );
        },
      ),
    );
  }
}

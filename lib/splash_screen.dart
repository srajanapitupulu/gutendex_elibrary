import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gutendex_elibrary/helpers/constants/strings.dart';
import 'package:gutendex_elibrary/main_screen.dart';
import 'package:gutendex_elibrary/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = "/main";

  const SplashScreen({super.key});

  final storage = const FlutterSecureStorage();

  Future<bool> firstInstallChecker() async {
    String? token = await storage.read(key: isFirstInstall) ?? "";
    if (token.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool>(
          future: firstInstallChecker(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/SplashBG.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: const CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return ErrorWidget(snapshot.error!);
            } else {
              if (snapshot.data == true) {
                return const MainScreen();
              } else {
                return const OnboardingScreen();
              }
            }
          },
        ),
      ),
    );
  }
}

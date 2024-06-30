import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gutendex_elibrary/helpers/constants/strings.dart';

import 'package:lottie/lottie.dart';
import 'package:gutendex_elibrary/helpers/ui/custom_button.dart';
import 'package:gutendex_elibrary/main_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static const routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(pages: [
        OnboardingPageModel(
          title: 'Browse Our Library',
          description: 'Curated e-books based on your interest',
          imageUrl: 'assets/animations/onboarding2.json',
          bgColor: Colors.white,
        ),
        OnboardingPageModel(
          title: 'Read With Ease',
          description: 'Read e-books directly in your devices',
          imageUrl: 'assets/animations/onboarding3.json',
          bgColor: Colors.white,
        ),
      ]),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter(
      {super.key, required this.pages, this.onSkip, this.onFinish});

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  // Store the currently visible page
  int _currentPage = 0;

  final storage = const FlutterSecureStorage();

  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);

  Future<bool> setFirstInstall() async {
    await storage.write(key: isFirstInstall, value: isFirstInstall);
    String? token = await storage.read(key: isFirstInstall) ?? "";
    if (token.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xff8F17D8),
          elevation: 0.0,
          toolbarOpacity: _currentPage != 0 ? 1.0 : 0.0,
          leading: TextButton(
              onPressed: () {
                if (_currentPage == 0) {
                  widget.onFinish?.call();
                } else {
                  _pageController.animateToPage(_currentPage - 1,
                      curve: Curves.easeInOutCubic,
                      duration: const Duration(milliseconds: 250));
                }
              },
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.comfortable,
                foregroundColor: const Color(0xff8F17D8),
                textStyle:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              child: const Icon(Icons.arrow_back_ios_new)),
          title: const Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                ),
              ),
            ],
          )),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                // Pageview to render each page
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    // Change current page when pageview changes
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                child: Text(item.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                child: Text(item.description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400)),
                              )
                            ])),
                        // Current page indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.pages
                              .map((item) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: _currentPage ==
                                            widget.pages.indexOf(item)
                                        ? 30
                                        : 8,
                                    height: 8,
                                    margin: const EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                        color: _currentPage ==
                                                widget.pages.indexOf(item)
                                            ? const Color(0xffF6B434)
                                            : const Color(0xffEBEBEB),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ))
                              .toList(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Lottie.asset(
                              item.imageUrl,
                              width: 300,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                height: 40,
                child: CustomButton(
                  buttonType: CustomButtonType.primary,
                  onPressed: () async {
                    if (_currentPage == widget.pages.length - 1) {
                      if (await setFirstInstall()) {
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      }
                    } else {
                      _pageController.animateToPage(_currentPage + 1,
                          curve: Curves.easeInOutCubic,
                          duration: const Duration(milliseconds: 250));
                    }
                  },
                  child: Text(
                    _currentPage == widget.pages.length - 1
                        ? "Get Started"
                        : "Next",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel(
      {required this.title,
      required this.description,
      required this.imageUrl,
      this.bgColor = Colors.blue,
      this.textColor = Colors.black});
}

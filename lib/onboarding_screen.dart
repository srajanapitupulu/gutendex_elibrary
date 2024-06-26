import 'package:flutter/material.dart';
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
          title: 'Swipe up to see more',
          description:
              'News and article based on what’s happening and your interest',
          imageUrl:
              const Image(image: AssetImage('assets/icons/onboard_1.png')),
          bgColor: Colors.white,
        ),
        OnboardingPageModel(
          title: 'Swipe left to see detail',
          description: 'See news detail by swiping left on post',
          imageUrl:
              const Image(image: AssetImage('assets/icons/onboard_2.png')),
          bgColor: Colors.white,
        ),
        OnboardingPageModel(
          title: 'Save your time with Snap Mode',
          description:
              'Read snap under one minute without losing the main topic',
          imageUrl:
              const Image(image: AssetImage('assets/icons/onboard_3.png')),
          bgColor: Colors.white,
        ),
        OnboardingPageModel(
          title: 'Read with no distraction',
          description:
              'No messy layout and disturbing ads when reading your news or article',
          imageUrl:
              const Image(image: AssetImage('assets/icons/onboard_4.png')),
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

  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);

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
          title: Row(
            children: [
              const Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                ),
              ),
              TextButton(
                  onPressed: () {
                    _pageController.animateToPage(widget.pages.length - 1,
                        curve: Curves.easeInOutCubic,
                        duration: const Duration(milliseconds: 250));
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.comfortable,
                    foregroundColor: const Color(0xff8F17D8),
                    textStyle: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Skip",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w400))),
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
                            child: item.imageUrl,
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
                  onPressed: () {
                    if (_currentPage == widget.pages.length - 1) {
                      // widget.onFinish?.call();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                      );
                    } else {
                      _pageController.animateToPage(_currentPage + 1,
                          curve: Curves.easeInOutCubic,
                          duration: const Duration(milliseconds: 250));
                    }
                  },
                  child: Text(
                    _currentPage == widget.pages.length - 1
                        ? "Get Started to Mata"
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
  final Image imageUrl;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel(
      {required this.title,
      required this.description,
      required this.imageUrl,
      this.bgColor = Colors.blue,
      this.textColor = Colors.black});
}

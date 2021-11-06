import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/onboarding/onboarding.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/authentication/onboarding/components/pages/onboarding_page_1.dart';
import 'package:seeds/screens/authentication/onboarding/components/pages/onboarding_page_2.dart';

import 'components/pages/onboarding_page_3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OnboardingState();
}

class OnboardingState extends State<OnboardingScreen> {
  final CarouselController _controller = CarouselController();
  int _selectedIndex = 0;

  void onPageChangeForward() {
    if (_selectedIndex < 2) {
      setState(() {
        _selectedIndex = _selectedIndex + 1;
        _controller.jumpToPage(_selectedIndex);
      });
    }
  }

  void onPageChangeBackward() {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = _selectedIndex - 1;
        _controller.jumpToPage(_selectedIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            CarouselSlider(
              carouselController: _controller,
              items: [const FirstPage(), const SecondPage(), const ThirdPage()],
              options: CarouselOptions(
                height: height * 0.91,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, _) => setState(() => _selectedIndex = index),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  if (_selectedIndex != 0)
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 100,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => onPageChangeBackward(),
                      ),
                    )
                  else
                    const SizedBox(width: 100),
                  Expanded(
                    child: DotsIndicator(
                      dotsCount: 3,
                      position: _selectedIndex.toDouble(),
                      decorator: const DotsDecorator(
                        spacing: EdgeInsets.all(2.0),
                        size: Size(10.0, 2.0),
                        shape: Border(),
                        color: AppColors.darkGreen2,
                        activeColor: AppColors.green1,
                        activeSize: Size(18.0, 2.0),
                        activeShape: Border(),
                      ),
                    ),
                  ),
                  if (_selectedIndex == 2)
                    Container(
                      width: 100,
                      child: TextButton(
                        onPressed: () => NavigationService.of(context).navigateTo(Routes.login, null, true),
                        child: Text("Join Now".i18n, style: Theme.of(context).textTheme.subtitle1),
                      ),
                    )
                  else
                    Container(
                      alignment: Alignment.centerRight,
                      width: 100,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => onPageChangeForward(),
                      ),
                    ),
                  const SizedBox(width: 20)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

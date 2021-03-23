import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/screens/onboarding/components/pages/onboarding_page_1.dart';
import 'package:seeds/v2/screens/onboarding/components/pages/onboarding_page_2.dart';
import 'components/pages/onboarding_page_3.dart';
import 'package:seeds/i18n/onboarding.i18n.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OnboardingState();
  }
}

class OnboardingState extends State<OnboardingScreen> {
  final CarouselController _controller = CarouselController();
  int _selectedIndex = 0;

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void onPageChangeForward(int index, CarouselPageChangedReason changeReason) {
    if (index < 2) {
      setState(() {
        _controller.jumpToPage(index + 1);
        _selectedIndex = index + 1;
      });
    }
  }

  void onPageChangeBackward(int index, CarouselPageChangedReason changeReason) {
    if (index == 0) {
    } else {
      setState(() {
        _controller.jumpToPage(index - 1);
        _selectedIndex = index - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Column(
      children: <Widget>[
        CarouselSlider(
          carouselController: _controller,
          items: [
            FirstPage(),
            SecondPage(),
            ThirdPage(),
          ],
          options: CarouselOptions(
            height: height * 0.91,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: onPageChange,
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            _selectedIndex != 0
                ? Container(
                    alignment: Alignment.centerLeft,
                    width: 100,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        onPageChangeBackward(_selectedIndex, CarouselPageChangedReason.manual);
                      },
                    ),
                  )
                : const SizedBox(width: 100),
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
            _selectedIndex == 2
                ? Container(
                    width: 100,
                    child: TextButton(
                      child: Text(
                        "Join Now".i18n,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      onPressed: () {
                        NavigationService.of(context).navigateTo(Routes.login, null, true);
                      },
                    ))
                : Container(
                    alignment: Alignment.centerRight,
                    width: 100,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        onPageChangeForward(_selectedIndex, CarouselPageChangedReason.manual);
                      },
                    )),
            const SizedBox(
              width: 20,
            )
          ],
        )
      ],
    ));
  }
}

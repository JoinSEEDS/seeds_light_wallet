import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:seeds/components/dots_indicator.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/authentication/onboarding/components/pages/onboarding_page_1.dart';
import 'package:seeds/screens/authentication/onboarding/components/pages/onboarding_page_2.dart';
import 'package:seeds/screens/authentication/onboarding/components/pages/onboarding_page_3.dart';
import 'package:seeds/utils/build_context_extension.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<StatefulWidget> createState() => OnboardingState();
}

class OnboardingState extends State<OnboardingScreen> {
  final CarouselController _controller = CarouselController();
  int _selectedIndex = 0;

  void _onPageChangeForward() {
    if (_selectedIndex < 2) {
      setState(() {
        _selectedIndex = _selectedIndex + 1;
        _controller.jumpToPage(_selectedIndex);
      });
    }
  }

  void _onPageChangeBackward() {
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
                  Expanded(
                    child: _selectedIndex != 0
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => _onPageChangeBackward(),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(child: DotsIndicator(dotsCount: 3, position: _selectedIndex.toDouble())),
                  if (_selectedIndex == 2)
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () => NavigationService.of(context).navigateTo(Routes.login, null, true),
                              child: Text(
                                context.loc.onboardingJoinButtonTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => _onPageChangeForward(),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

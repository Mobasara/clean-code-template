import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:clean_code_template/app/core/utils/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/data/local/local_data.dart';
import '../../../../core/route/app_route.gr.dart';

part '../widgets/on_board_page.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

@RoutePage()
class OnBoardScreen extends ConsumerWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = PageController();
    final currentPage = ref.watch(currentPageProvider);

    final pages = [
      _OnboardPage(
        image:
            'https://www.kindpng.com/picc/m/206-2065130_hey-there-calligraphy-hd-png-download.png',
        title: 'Discover Amazing Places',
        subtitle:
            'Find unique travel destinations and explore beautiful places around the world.',
      ),
      _OnboardPage(
        image:
            'https://thumbs.dreamstime.com/b/vector-illustration-hi-there-sticker-social-media-content-isolated-white-background-vector-cartoon-illustration-hi-125206467.jpg',
        title: 'Easy Booking Experience',
        subtitle:
            'Book your favorite trips, hotels, and cars easily and securely in one app.',
      ),
      _OnboardPage(
        image:
            'https://i0.wp.com/137.220.55.84/wp-content/uploads/2024/06/Hey-There-Its-Yogi-Bear-1964-Where-to-Watch-It-.jpg',
        title: 'Enjoy Your Journey',
        subtitle:
            'Relax and enjoy a hassle-free travel experience tailored to your needs.',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                ref.read(currentPageProvider.notifier).state = index;
              },
              itemBuilder: (_, index) => pages[index],
            ),

            // Bottom Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button
                  if (currentPage != pages.length - 1)
                    TextButton(
                      onPressed: () {
                        pageController.jumpToPage(pages.length - 1);
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  else
                    const SizedBox(width: 60),

                  // Page Indicator
                  SmoothPageIndicator(
                    controller: pageController,
                    count: pages.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.blueAccent,
                      dotColor: Colors.grey,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 6,
                    ),
                  ),

                  // Next / Get Started Button
                  TextButton(
                    onPressed: () {
                      if (currentPage < pages.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.localData.setOnboardingComplete(true);
                        context.router.replace(const LoginRoute());
                      }
                    },
                    child: Text(
                      currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

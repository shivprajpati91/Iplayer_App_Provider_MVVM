import 'package:flutter/material.dart';
import 'package:iplayer/FadeAnimation.dart';
import 'package:lottie/lottie.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'Profile_Setup.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];
  final PageController _pageController = PageController();
  int currentPage = 0;

  final GlobalKey _welcomeTextKey = GlobalKey();
  final GlobalKey _playButtonKey = GlobalKey();
  final GlobalKey _playlistKey = GlobalKey();
  final GlobalKey _favoritesKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();


  void initState() {
    super.initState();

    _pageController.addListener(() {
      int newPage = _pageController.page?.round() ?? 0;
      if (newPage != currentPage) {
        setState(() {
          currentPage = newPage;
        });
        Future.delayed(Duration(milliseconds: 500), showTutorial);
      }
    });

    /// **Ensure context is valid before calling showTutorial()**
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showTutorial();
      }
    });
  }

  void showTutorial() {
    if (!mounted) return; // Ensure widget is still in the tree

    targets.clear(); // Reset targets before adding new ones

    if (currentPage == 1) {
      targets.add(
        TargetFocus(
          identify: "WelcomeText",
          keyTarget: _welcomeTextKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                "Enjoy seamless video playback.",
                style: TextStyle(color: Colors.blue.shade100, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else if (currentPage == 0) {
      targets.add(
        TargetFocus(
          identify: "PlayButton",
          keyTarget: _playButtonKey,
          shape: ShapeLightFocus.Circle,color: Colors.transparent,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                " play your favorite videos instantly.",
                style: TextStyle(color: Colors.pink.shade50, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else if (currentPage == 2) {
      targets.add(
        TargetFocus(
          identify: "Favorites",
          keyTarget: _favoritesKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                "Save your favorite videos for quick access.",
                style: TextStyle(color: Colors.pink.shade50, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    if (targets.isNotEmpty) {
      tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black54,
        textSkip: "SKIP",
        paddingFocus: 8,
        onFinish: () => print("Tutorial Finished!"),
        onClickTarget: (target) {
          print("Clicked on: ${target.identify}");
        },
      );

      // Ensure the tutorial runs after the widget tree is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tutorialCoachMark.show(context: context);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              buildPage2(),
              buildPage1(),
              buildPage3(),
            ],
          ),
          // Page Indicator
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.12,
            left: MediaQuery.of(context).size.width * 0.40,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.black,
                dotHeight: MediaQuery.of(context).size.height * 0.01,
                dotWidth: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
          ),
          // Skip Button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            right: MediaQuery.of(context).size.width * 0.05,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
            ),
          ),
          // Next Button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.03,
            right: MediaQuery.of(context).size.width * 0.05,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.018,
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (currentPage < 2) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen())
                  );
                }
              },
              child: Text(
                currentPage == 2 ? "Get Started" : "Next",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      )
    );
  }
  Widget buildPage1(){
    return Stack(
      children: [
        // Title Text
        Positioned(
          top: MediaQuery.of(context).size.height * 0.06,
          left: MediaQuery.of(context).size.width * 0.05,
          child: Text(
            "SLEEPLAY",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        // Subheading Text
        Positioned(
          top: MediaQuery.of(context).size.height * 0.22,
          child: Text(
            "  S O U N D",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.05,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Container(
                width: 395,
                child: Lottie.asset("Anim/onlottite2.json",fit: BoxFit.fill))),
        // Animated Image
        Positioned(
          top: MediaQuery.of(context).size.height * 0.01,
          child: FadeAnimation(
            delay: 2,
            translateX: 50,
            translateY: 50,
            child: MovingAnimation(
              child: Image.asset("onboarding_image/on1.png"),
            ),
          ),
        ),
        // Description Text
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.20,
          left: MediaQuery.of(context).size.width * 0.07,
          child: Container(
            key: _welcomeTextKey,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Column(
              children: [
                Text(
                  "Blazing Fast Performance",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  "Enjoy uninterrupted streaming with\n         a powerful video engine.",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPage2() {
    return Stack(
      children: [
        // Main Heading
        Positioned(
          top: MediaQuery.of(context).size.height * 0.24,
          left: MediaQuery.of(context).size.width * 0.10,
          child: Text(
            "C O N N E C T\nP L A Y",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.05,
              color: Colors.black,
            ),
            key: _playButtonKey,
          ),
        ),
        // Animated Image
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: MediaQuery.of(context).size.width * 0.15,
          child: FadeAnimation(
            delay: 2,
            translateY: 50,
            translateX: 50,
            child: MovingAnimation(
              child: Container(
                  height: 400,
                  child: Lottie.asset("Anim/onlottite1.json"))),
            ),
          ),

        // Title Text
        Positioned(
          top: MediaQuery.of(context).size.height * 0.06,
          left: MediaQuery.of(context).size.width * 0.05,
          child: Text(
            "SLEEPLAY",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        // Description Text
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.20,
          left: MediaQuery.of(context).size.width * 0.11,
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Column(
              children: [
                Text(
                  "Crystal Clear Experience",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.028,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  " Watch videos in stunning HD quality\n              with zero buffering.",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPage3() {
    return Stack(
      children: [
        // Main Heading
        Positioned(
          top: MediaQuery.of(context).size.height * 0.18,
          child: Text(
            "  B A S I C\n  AI F e a t u r e",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.05,
              color: Colors.black,
            ),
          ),
        ),
        // Animated Image
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          left: MediaQuery.of(context).size.width * 0.050,
          child: FadeAnimation(
            delay: 2,
            translateY: 50,
            translateX: 50,
              child: MovingAnimation(
              child: Container(
                  height: 400,
                  child: Lottie.asset("Anim/onlottie3rd.json")),
            ),
          ),),
        Positioned(
            bottom: 90,
            right: -20,
            child: Container(
                height: 300,
                child: Lottie.asset("Anim/onlottie3.json"))),

        Positioned(
          top: MediaQuery.of(context).size.height * 0.06,
          left: MediaQuery.of(context).size.width * 0.05,
          child: Text(
            "SLEEPLAY",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.20,
          left: MediaQuery.of(context).size.width * 0.08,
          child: Container(
            key: _favoritesKey,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Column(
              children: [
                Text(
                  "Support with AI Chatbot",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.028,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  "            Join us and explore the limitless\npossibilities               with AI-powered solutions.",
                  style: TextStyle(color: Colors.black),
                ),],
            ),),
        ),],
    );
  }
}
class MovingAnimation extends StatefulWidget {
  final Widget child;

  const MovingAnimation({Key? key, required this.child}) : super(key: key);

  @override
  _MovingAnimationState createState() => _MovingAnimationState();
}
class _MovingAnimationState extends State<MovingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationX;
  late Animation<double> _animationY;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animationX = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _animationY = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animationX.value, _animationY.value),
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

class AnimationProvider extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _textAnimationController;
  late final AnimationController _textFieldAnimationController;
  double screenWidth = 0;
  double alignAnimation = -1; // The current alignment value based on scroll position.
  // initializes animation controllers and sets up a scroll listener.
  AnimationProvider(TickerProvider vsync) {
    _textAnimationController = AnimationController(
        vsync: vsync, duration: Duration(milliseconds: 500));
    _textFieldAnimationController = AnimationController(
        vsync: vsync, duration: Duration(milliseconds: 600));
    _scrollController.addListener(() {
      _scroll();
    });
  }
  //getters
  ScrollController get scrollController => _scrollController;
  AnimationController get textAnimationController => _textAnimationController;
  AnimationController get textFieldAnimationController => _textFieldAnimationController;

  ///Updates screen width and returns value of animation controlled by screenWidth
  double updateScreenWidthAndGetAlignment(double screenWidth) {
    this.screenWidth = screenWidth;
    return alignAnimation;
  }

  /// Handles scroll events and updates animations based on scroll position.
  void _scroll() {
    // If scrolling is not active, return early.
    if (!scrollController.position.isScrollingNotifier.value) return;
    // Calculates alignment value (from -1 to 1)  by scroll position and screen size.
    alignAnimation = (scrollController.position.pixels / screenWidth * 3).clamp(0, 2) - 1;
    // Defines _textAnimationController value by value of alignment.
    if (alignAnimation >= 0.0) {
      textAnimationController.forward();
    } else if (textAnimationController.isForwardOrCompleted) {
      textAnimationController.reverse();
    }
    // Defines _textFieldAnimationController by scroll position.
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.78) {
      if (!textFieldAnimationController.isCompleted) {
        textFieldAnimationController.forward();
      }
    } else {
      textFieldAnimationController.reverse();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    textAnimationController.dispose();
    textFieldAnimationController.dispose();
    scrollController.dispose();
  }
}

import 'package:flutter/material.dart';
class FadeAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  final double translateX;
  final double translateY;

  const FadeAnimation({
    required this.child,
    this.delay = 0,
    this.translateX = 0.0,
    this.translateY = 0.0,
  });

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> {
  late double translateX;
  late double translateY;
  late bool _isVisible;

  @override
  void initState() {
    super.initState();
    translateX = widget.translateX;
    translateY = widget.translateY;
    _isVisible = false;


    Future.delayed(Duration(milliseconds: widget.delay), () {
      setState(() {
        _isVisible = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
      child: TweenAnimationBuilder(
        tween: Tween<Offset>(
          begin: Offset(translateX, translateY,),
          end: Offset.zero,
        ),
        duration: Duration(milliseconds: 500),
        builder: (context, Offset offset, child) {
          return Transform.translate(
            offset: offset,
            child: child,
          );},
        child: widget.child,
      ),
    );
  }
}




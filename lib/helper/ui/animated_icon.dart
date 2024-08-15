import 'package:flutter/material.dart';

/// Widget that animates an icon's size.
///
/// The key can be used to access the state
/// and the controller of the animation.
///
/// {@category Widgets}
class SizeAnimatedIcon extends StatefulWidget {
  final int beginSize;
  final int endSize;
  final Duration duration;
  final IconData iconData;
  final Curve curve;
  final Color iconColor;
  final bool autostart;

  const SizeAnimatedIcon(
      {super.key,
      required this.beginSize,
      required this.endSize,
      required this.duration,
      required this.iconData,
      required this.iconColor,
      this.autostart = false,
      this.curve = Curves.easeIn});

  @override
  State<SizeAnimatedIcon> createState() => SizeAnimatedIconState();
}

class SizeAnimatedIconState extends State<SizeAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curve;
  late Animation<int> _animation;

  AnimationController get controller => _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _curve = CurvedAnimation(parent: _controller, curve: widget.curve);
    _animation =
        IntTween(begin: widget.beginSize, end: widget.endSize).animate(_curve)
          ..addListener(() {
            setState(() {});
          });
    if (widget.autostart) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.endSize.toDouble(),
        height: widget.endSize.toDouble(),
        child: Icon(widget.iconData,
            color: widget.iconColor, size: _animation.value.toDouble()));
  }
}

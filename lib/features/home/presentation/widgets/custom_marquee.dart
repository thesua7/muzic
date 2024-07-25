import 'package:flutter/material.dart';

class CustomMarquee extends StatefulWidget {
  final String text; // Title of the marquee text
  final TextStyle style; // Text style
  final double velocity; // Pixels per second
  final double width; // Width of the marquee container

  CustomMarquee({
    required this.text,
    required this.style,
    this.velocity = 50.0,
    required this.width,
  });

  @override
  _CustomMarqueeState createState() => _CustomMarqueeState();
}

class _CustomMarqueeState extends State<CustomMarquee> {
  late ScrollController _scrollController;
  double _textWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTextWidth();
      _startMarquee();
    });
  }

  void _calculateTextWidth() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );
    textPainter.layout();
    setState(() {
      _textWidth = textPainter.width;
    });
  }

  void _startMarquee() {
    if (_textWidth <= widget.width) return; // No need to scroll if text is shorter than container

    final scrollDuration = Duration(milliseconds: (_textWidth / widget.velocity * 1000).toInt());
    _scrollController.animateTo(
      _textWidth,
      duration: scrollDuration,
      curve: Curves.linear,
    ).whenComplete(() {
      _scrollController.jumpTo(0.0);
      _startMarquee();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Builder(
          builder: (context) {
            if (_textWidth == 0) {
              return SizedBox(width: widget.width); // Placeholder until text width is calculated
            }
            return Container(
              width: _textWidth + widget.width, // Ensure the container is wide enough for scrolling
              child: Text(
                widget.text,
                style: widget.style,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

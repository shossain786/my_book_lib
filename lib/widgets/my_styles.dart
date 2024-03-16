import 'package:flutter/material.dart';

class ThreeDText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const ThreeDText(this.text, {Key? key, this.style = const TextStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(-0.2)
        ..rotateY(0.0),
      alignment: Alignment.center,
      child: Text(
        text,
        style: style.copyWith(
          shadows: [
            Shadow(
              offset: const Offset(-3, -3),
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
            ),
            Shadow(
              offset: const Offset(2, 2),
              color: Colors.white.withOpacity(0.5),
              blurRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}

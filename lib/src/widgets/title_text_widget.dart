import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  final String text1;
  final String text2;
  final double fontSize;

  const TitleTextWidget({
    Key? key,
    required this.text1,
    required this.text2,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: text1,
              style:
                  const TextStyle(color: Colors.white, fontFamily: 'DMSerif'),
            ),
            TextSpan(
              text: text2,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 185, 0),
                fontFamily: 'DMSerif',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

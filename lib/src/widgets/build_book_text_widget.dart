import 'package:flutter/material.dart';

class BuildText extends StatelessWidget {
  final String text;
  final int maxLength;
  final int fontsizeBook;

  const BuildText({
    Key? key,
    required this.text,
    required this.maxLength,
    required this.fontsizeBook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        text.length <= maxLength ? text : '${text.substring(0, maxLength)}...',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontsizeBook.toDouble(),
        ),
      ),
    );
  }
}

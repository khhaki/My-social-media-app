import 'package:clonetwit/theme/theme.dart';
import 'package:flutter/material.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];
    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(TextSpan(
            text: "$element ",
            style: TextStyle(
                color: Pallete.blueColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)));
      } else if (element.startsWith("www.") || element.startsWith("http")) {
        textspans.add(TextSpan(
            text: "$element ",
            style: TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            )));
      } else {
        textspans.add(TextSpan(
            text: "$element ",
            style: TextStyle(
              fontSize: 18,
            )));
      }
    });
    return RichText(text: TextSpan(children: textspans));
  }
}

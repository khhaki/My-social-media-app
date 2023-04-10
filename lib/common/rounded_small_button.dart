import 'package:clonetwit/theme/pallete.dart';
import 'package:flutter/material.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color textColor;
  final Color backgroundColor;
  const RoundedSmallButton({
    Key? key,
    required this.onTap,
    required this.label,
    this.textColor = Pallete.backgroundColor,
    this.backgroundColor = Pallete.whiteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        backgroundColor: backgroundColor,
        labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      ),
    );
  }
}

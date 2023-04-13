// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:clonetwit/constants/assets_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Colors.blue,
        height: 32,
      ),
      centerTitle: true,
    );
  }

  static List<Widget> bottomTabBarPages = [
    Text(
      'Feed screen',
      style: TextStyle(color: Colors.white),
    ),
    Text('search screen', style: TextStyle(color: Colors.white)),
    Text('not screen', style: TextStyle(color: Colors.white)),
  ];
}

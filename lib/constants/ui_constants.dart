// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:clonetwit/constants/assets_constant.dart';
import 'package:clonetwit/features/explore/views/explore_view.dart';
import 'package:clonetwit/features/tweet/widgets/tweet_list.dart';
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

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    ExplorView(),
    Text('not screen', style: TextStyle(color: Colors.white)),
  ];
}

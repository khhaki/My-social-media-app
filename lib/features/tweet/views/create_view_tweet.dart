import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/common/rounded_small_button.dart';
import 'package:clonetwit/constants/assets_constant.dart';
import 'package:clonetwit/core/utils.dart';
import 'package:clonetwit/features/auth/controller/auth_controller.dart';
import 'package:clonetwit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  const CreateTweetScreen({super.key});
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateTweetScreen());
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final tweetTextcontroller = TextEditingController();
  List<File> imges = [];

  @override
  void dispose() {
    tweetTextcontroller.dispose();
    super.dispose();
  }

  void onPickImages() async {
    await pickImages();
    setState(() {});
  }

  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                size: 30,
              )),
          actions: [
            RoundedSmallButton(
              onTap: () {},
              label: "tweet",
              textColor: Pallete.whiteColor,
              backgroundColor: Pallete.blueColor,
            )
          ],
        ),
        body: currentUser == null
            ? Loader()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.profilePic),
                          radius: 30,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: tweetTextcontroller,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            decoration: InputDecoration(
                                hintText: "what's happening?",
                                hintStyle: TextStyle(
                                    color: Pallete.greyColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                                border: InputBorder.none),
                            maxLines: null,
                          ),
                        )
                      ],
                    ),
                    if (imges.isNotEmpty)
                      CarouselSlider(
                        items: imges.map(
                          (file) {
                            return Image.file(file);
                          },
                        ).toList(),
                        options: CarouselOptions(
                            height: 400, enableInfiniteScroll: false),
                      )
                  ],
                ),
              ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Pallete.greyColor, width: 0.3))),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
                child: GestureDetector(
                    onTap: onPickImages,
                    child: SvgPicture.asset(AssetsConstants.galleryIcon)),
              ),
              Padding(
                padding:
                    const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
                child: SvgPicture.asset(AssetsConstants.gifIcon),
              ),
              Padding(
                padding:
                    const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
                child: SvgPicture.asset(AssetsConstants.emojiIcon),
              )
            ],
          ),
        ),
      ),
    );
  }
}

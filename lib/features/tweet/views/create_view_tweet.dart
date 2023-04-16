import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/common/rounded_small_button.dart';
import 'package:clonetwit/constants/assets_constant.dart';
import 'package:clonetwit/core/utils.dart';
import 'package:clonetwit/features/auth/controller/auth_controller.dart';
import 'package:clonetwit/features/tweet/cotroller/tweet_controller.dart';
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
  List<File> images = [];

  @override
  void dispose() {
    tweetTextcontroller.dispose();
    super.dispose();
  }

  void shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
        images: images, text: tweetTextcontroller.text, context: context);
    Navigator.pop(context);
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);
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
              onTap: shareTweet,
              label: "tweet",
              textColor: Pallete.whiteColor,
              backgroundColor: Pallete.blueColor,
            )
          ],
        ),
        body: isLoading || currentUser == null
            ? const Loader()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.profilePic),
                          radius: 30,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: tweetTextcontroller,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            decoration: const InputDecoration(
                                hintText: "what's happening?",
                                hintStyle: TextStyle(
                                    color: Pallete.greyColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                                border: InputBorder.none),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map(
                          (file) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Image.file(file));
                          },
                        ).toList(),
                        options: CarouselOptions(
                            height: 400, enableInfiniteScroll: false),
                      )
                  ],
                ),
              ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
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

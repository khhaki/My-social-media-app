import 'package:any_link_preview/any_link_preview.dart';
import 'package:clonetwit/common/common.dart';
import 'package:clonetwit/constants/assets_constant.dart';
import 'package:clonetwit/core/enums/tweet_type_enum.dart';
import 'package:clonetwit/features/auth/controller/auth_controller.dart';
import 'package:clonetwit/features/tweet/cotroller/tweet_controller.dart';
import 'package:clonetwit/features/tweet/widgets/carousel_image.dart';
import 'package:clonetwit/features/tweet/widgets/hashtag_text.dart';
import 'package:clonetwit/features/tweet/widgets/tweet_icon_button.dart';
import 'package:clonetwit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:clonetwit/models/tweet_model.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
            data: (user) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 35,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (tweet.retweetedBy.isNotEmpty)
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsConstants.retweetIcon,
                                    color: Pallete.greyColor,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${tweet.retweetedBy} retweeted',
                                    style: TextStyle(
                                        color: Pallete.greyColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    user.name,
                                    style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "@${user.name}.${timeago.format(tweet.tweeteddAt, locale: 'en_short')}",
                                  style: const TextStyle(
                                    color: Pallete.greyColor,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            //replied to
                            HashtagText(text: tweet.text),
                            if (tweet.tweetType == TweetType.image)
                              CarouselImage(
                                imageLinks: tweet.imageLinks,
                              ),
                            if (tweet.link.isNotEmpty) ...[
                              const SizedBox(
                                height: 4,
                              ),
                              AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: "http://${tweet.link}"),
                            ],
                            Container(
                              margin: const EdgeInsets.only(top: 10, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TweetIconButton(
                                      pathName: AssetsConstants.viewsIcon,
                                      text: (tweet.commentsIds.length +
                                              tweet.reshareCount +
                                              tweet.likes.length)
                                          .toString(),
                                      onTap: () {}),
                                  TweetIconButton(
                                      pathName: AssetsConstants.commentIcon,
                                      text:
                                          (tweet.commentsIds.length).toString(),
                                      onTap: () {}),
                                  TweetIconButton(
                                      pathName: AssetsConstants.retweetIcon,
                                      text: (tweet.reshareCount).toString(),
                                      onTap: () {
                                        ref
                                            .read(tweetControllerProvider
                                                .notifier)
                                            .reschareTweet(
                                                tweet, currentUser, context);
                                      }),
                                  LikeButton(
                                    onTap: (isLiked) async {
                                      ref
                                          .read(
                                              tweetControllerProvider.notifier)
                                          .likeTweet(tweet, currentUser);
                                      return !isLiked;
                                    },
                                    isLiked:
                                        tweet.likes.contains(currentUser.uid),
                                    size: 25,
                                    likeBuilder: (isLiked) {
                                      return isLiked
                                          ? SvgPicture.asset(
                                              AssetsConstants.likeFilledIcon,
                                              color: Pallete.redColor,
                                            )
                                          : SvgPicture.asset(
                                              AssetsConstants.likeOutlinedIcon,
                                              color: Pallete.greyColor,
                                            );
                                    },
                                    likeCount: tweet.likes.length,
                                    countBuilder: (likeCount, isLiked, text) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text(
                                          text,
                                          style: TextStyle(
                                              color: isLiked
                                                  ? Pallete.redColor
                                                  : Pallete.greyColor,
                                              fontSize: 16),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.share_outlined,
                                        size: 25,
                                        color: Pallete.greyColor,
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Pallete.greyColor,
                  )
                ],
              );
            },
            error: (error, StackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader());
  }
}

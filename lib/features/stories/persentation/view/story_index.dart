import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/core/helper/get_maxline.dart';
import 'package:status_app/features/stories/domain/stories.dart';

final maxLineProvider = StateProvider.autoDispose<int?>(
  (ref) => 1,
);

class StoriesIndex extends ConsumerWidget {
  const StoriesIndex({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final maxLines = ref.watch(maxLineProvider);

    TextStyle style = TextStyle(
      fontSize: size.height * p1,
      fontWeight: FontWeight.normal,
    );

    int getLines = getMaxLines(story.description, style, size.width);

    return GestureDetector(
      onTap: () {
        AppRoutes.goRouter.pushNamed(AppRoutes.detailStory, extra: story);
      },
      child: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: size.width * 0.05,
                    child: const Icon(Icons.person),
                  ),
                  Gap(size.width * 0.03),
                  Text(
                    story.name,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: size.height * p1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            /// image
            Gap(size.height * 0.01),
            Image.network(
              story.imageUrl,
              height: size.width,
              width: size.width,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  Icons.warning,
                  size: size.height * 0.05,
                ),
              ),
            ),

            /// description
            Gap(size.height * 0.01),
            GestureDetector(
              onTap: () {
                if (getLines > 1) {
                  getLines = getMaxLines(story.description, style, size.width);

                  ref.read(maxLineProvider.notifier).state = null;
                }

                return;
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        maxLines: maxLines,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${story.name}  ",
                              style: TextStyle(
                                fontSize: size.height * p1,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: story.description,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: size.height * p1,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: maxLines != null && getLines > 1 ? true : false,
                      child: Text(
                        "   selengkapnya",
                        style: TextStyle(
                            fontSize: size.height * p1,
                            color: Colors.grey.shade600),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Gap(size.height * 0.02),
          ],
        ),
      ),
    );
  }
}

class StoryIndexS extends StatelessWidget {
  const StoryIndexS({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: size.width * 0.05,
              ),
              Gap(size.width * 0.03),
              SizedBox(
                height: size.height * 0.02,
                width: size.width * 0.5,
              ),
            ],
          ),
          Gap(size.height * 0.01),
          SizedBox(
            height: size.width,
            width: size.width,
          ),
          Gap(size.height * 0.01),
          SizedBox(
            height: size.height * 0.02,
            width: size.width * 0.5,
          ),
          Gap(size.height * 0.02),
        ],
      ),
    );
  }
}

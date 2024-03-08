import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/features/stories/domain/stories.dart';

class StoriesIndex extends StatelessWidget {
  const StoriesIndex({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  style: TextStyle(
                    fontSize: size.height * p1,
                  ),
                ),
              ],
            ),
          ),
          Gap(size.height * 0.01),
          Image.network(
            story.imageUrl,
            height: size.width,
            width: size.width,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.warning,
              size: size.height * 0.05,
            ),
          ),
          Gap(size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
            child: Text(
              story.description,
              style: TextStyle(
                fontSize: size.height * p1,
              ),
            ),
          ),
          Gap(size.height * 0.02),
        ],
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

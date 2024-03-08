import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/features/stories/persentation/controller/story.dart';
import 'package:status_app/features/stories/persentation/view/stories.dart';

class HomeFragment extends ConsumerWidget {
  const HomeFragment({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final story = ref.watch(
      storyIndexControllerProv(
        const StoryIndexParams(
          page: 1,
          size: 20,
          location: 0,
        ),
      ),
    );
    
    return story.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(
              storyIndexControllerProv(
                const StoryIndexParams(
                  page: 1,
                  size: 20,
                  location: 0,
                ),
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return StoriesIndex(
                  story: data[index],
                );
              },
              itemCount: data.length,
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/svg/error.svg",
                  height: size.height * 0.3,
                  width: size.width * 0.5,
                  fit: BoxFit.cover,
                ),
                Gap(size.height * 0.03),
                Text(
                  "Maaf Terjadi Kesalahan Pada Aplikasi",
                  style: TextStyle(
                    fontSize: size.height * p1,
                  ),
                ),
                Text(
                  "$error",
                  style: TextStyle(
                    fontSize: size.height * p1,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () {
          //   return ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     shrinkWrap: true,
          //     itemBuilder: (context, index) {
          //       return const StoryIndexS();
          //     },
          //     itemCount: 5,
          //   );
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
  }
}
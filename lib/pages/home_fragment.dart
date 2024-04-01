import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:status_app/core/apis/stories.dart';
import 'package:status_app/features/stories/data/stories_repository.dart';
import 'package:status_app/features/stories/domain/stories.dart';
import 'package:status_app/features/stories/persentation/controller/story_index.dart';
import 'package:status_app/features/stories/persentation/view/story_index.dart';

final pagingControllerProvider =
    StateProvider.autoDispose<PagingController<int, Story>>((ref) {
  return PagingController(firstPageKey: 1);
});

class HomeFragment extends ConsumerStatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends ConsumerState<HomeFragment> {
  @override
  void initState() {
    super.initState();
    final pagingController = ref.read(pagingControllerProvider);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  void _fetchPage(int pageKey) async {
    try {
      final newItems = await StoriesRepository(StoryApi()).index(
        page: pageKey,
        size: 3, // You can adjust the size here
        location: 0,
      );
      final isLastPage =
          newItems.length < 3; // You can adjust the page size here
      final pagingController = ref.read(pagingControllerProvider);
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;

        Future.delayed(
          const Duration(seconds: 1),
          () {
            pagingController.appendPage(newItems, nextPageKey);
          },
        );
      }
    } catch (error) {
      final pagingController = ref.read(pagingControllerProvider);
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final pagingController = ref.watch(pagingControllerProvider);

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(
              storyIndexControllerProv(
                const StoryIndexParams(page: 1, size: 3, location: 0),
              ),
            );

            pagingController.refresh();
          },
          child: PagedListView<int, Story>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<Story>(
              animateTransitions: true,
              // [transitionDuration] has a default value of 250 milliseconds.
              transitionDuration: const Duration(milliseconds: 1000),
              itemBuilder: (context, item, index) => StoriesIndex(
                story: item,
              ),
            ),
          ),
        );
      },
    );
  }
}

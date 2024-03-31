import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:status_app/core/apis/stories.dart';
import 'package:status_app/features/stories/data/stories_repository.dart';
import 'package:status_app/features/stories/domain/stories.dart';
import 'package:status_app/features/stories/persentation/controller/story_index.dart';
import 'package:status_app/features/stories/persentation/view/story_index.dart';

class HomeFragment extends ConsumerStatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends ConsumerState<HomeFragment> {
  final _pageSize = 3;

  final PagingController<int, Story> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await StoriesRepository(StoryApi()).index(
        page: pageKey,
        size: _pageSize,
        location: 0,
      );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        Future.delayed(
          const Duration(seconds: 1),
          () {
            _pagingController.appendPage(newItems, nextPageKey);
          },
        );
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final story = ref.watch(
          storyIndexControllerProv(
            const StoryIndexParams(page: 1, size: 3, location: 0),
          ),
        );

        return story.when(
          data: (data) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(
                  storyIndexControllerProv(
                    const StoryIndexParams(page: 1, size: 3, location: 0),
                  ),
                );

                _pagingController.refresh();
              },
              child: PagedListView<int, Story>(
                pagingController: _pagingController,
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
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

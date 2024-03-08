import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:status_app/features/stories/data/stories_repository.dart';
import 'package:status_app/features/stories/domain/stories.dart';

class StoryIndexController extends StateNotifier<AsyncValue<List<Story>>> {
  StoryIndexController(this.repository, this.params)
      : super(const AsyncValue.loading()) {
    index();
  }

  final StoriesRepository repository;
  final StoryIndexParams params;

  Future index() async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.index(
        page: params.page,
        size: params.size,
        location: params.location,
      );
      state = AsyncValue.data(response);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

class StoryIndexParams extends Equatable {
  const StoryIndexParams({
    this.page,
    this.size,
    this.location,
  });

  final int? page;
  final int? size;
  final int? location;

  @override
  List<Object?> get props => [page, size, location];
}

final storyIndexControllerProv = AutoDisposeStateNotifierProviderFamily<
    StoryIndexController, AsyncValue<List<Story>>, StoryIndexParams>(
  (
    ref,
    params,
  ) {
    final repository = ref.read(storyRepoProv);
    return StoryIndexController(
      repository,
      params,
    );
  },
);

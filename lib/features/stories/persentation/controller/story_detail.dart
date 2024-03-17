import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:status_app/features/stories/data/stories_repository.dart';
import 'package:status_app/features/stories/domain/stories.dart';

class StoryDetailController extends StateNotifier<AsyncValue<Story>> {
  StoryDetailController(this.repo, this.params)
      : super(const AsyncValue.loading()) {
    detail();
  }

  final StoriesRepository repo;
  final StoryDetailParams params;

  Future detail() async {
    state = const AsyncValue.loading();
    try {
      final response = await repo.detail(id: params.id);
      state = AsyncValue.data(response);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

class StoryDetailParams extends Equatable {
  const StoryDetailParams({
    required this.id,
  });

  final String id;

  @override
  List<Object?> get props => [id];
}

final storyDetailControllerProv = AutoDisposeStateNotifierProviderFamily<
    StoryDetailController, AsyncValue<Story>, StoryDetailParams>((
  ref,
  params,
) {
  final repo = ref.read(storyRepoProv);
  return StoryDetailController(
    repo,
    params,
  );
});

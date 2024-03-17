import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:status_app/features/add_story/data/add_story_repository.dart';

class AddStoryController extends StateNotifier<AsyncValue> {
  AddStoryController(this.addStoryRepository, {required this.params})
      : super(const AsyncValue.loading()) {
    addStory();
  }

  final AddStoryRepository addStoryRepository;
  final AddStoryParams params;

  addStory() async {
    state = const AsyncValue.loading();
    try {
      final response = await addStoryRepository.addStory(
        description: params.description,
        image: params.image,
        fileName: params.fileName,
      );
      state = AsyncValue.data(response);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

class AddStoryParams extends Equatable {
  const AddStoryParams({
    required this.description,
    required this.fileName,
    required this.image,
    this.lat,
    this.lon,
  });

  final String description;
  final String fileName;
  final List<int> image;
  final double? lat;
  final double? lon;
  @override
  List<Object?> get props => [description, image, fileName];
}

final addStoryControllerProv = AutoDisposeStateNotifierProviderFamily<
    AddStoryController, AsyncValue, AddStoryParams>(
  (
    ref,
    params,
  ) {
    final addStoryRepository = ref.read(addStoryRepoProv);
    return AddStoryController(
      addStoryRepository,
      params: params,
    );
  },
);

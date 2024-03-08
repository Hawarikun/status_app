import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:status_app/core/apis/stories.dart';
import 'package:status_app/core/datas/shared_preferences.dart';
import 'package:status_app/core/helper/api.dart';
import 'package:status_app/features/stories/domain/stories.dart';

class StoriesRepository {
  StoriesRepository(this.api);

  final StoryApi api;

  Future<List<Story>> index({
    int? page,
    int? size,
    int? location,
  }) async {
    final token = await LocalPrefsRepository().getToken();
    return await ApiHelper().getData(
      uri: api.index(page: page, size: size, location: location),
      header: ApiHelper.headerStory(token!),
      builder: (data) {
        return List.generate(
          data["listStory"].length,
          (index) => Story.fromMap(
            data["listStory"][index],
          ),
        );
      },
    );
  }
}

final storyRepoProv = Provider(
  (ref) {
    final api = StoryApi();
    return StoriesRepository(
      api,
    );
  },
);

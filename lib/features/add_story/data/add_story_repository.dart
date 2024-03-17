import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:status_app/core/apis/add_story.dart';
import 'package:status_app/core/datas/shared_preferences.dart';
import 'package:status_app/core/helper/api.dart';

class AddStoryRepository {
  AddStoryRepository(this.api);
  final AddStoryApi api;

  addStory(
      {required String description,
      required List<int> image,
      required String fileName,
      double? lon,
      double? lat}) async {
    final token = await LocalPrefsRepository().getToken();

    return await ApiHelper().postImageData(
        uri: api.addStory(),
        builder: (data) {},
        header: ApiHelper.headerAddStory(token!),
        fileName: fileName,
        files: {
          "photo": image
        },
        fields: {
          "description": description,
        });
  }
}

final addStoryRepoProv = Provider((ref) {
  final api = AddStoryApi();
  return AddStoryRepository(api);
});

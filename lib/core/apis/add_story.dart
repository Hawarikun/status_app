import 'package:status_app/core/helper/api.dart';

class AddStoryApi {
  Uri addStory() {
    return ApiHelper.buildUri(endpoint: "/stories");
  }
}

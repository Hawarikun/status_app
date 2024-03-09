import 'package:status_app/core/helper/api.dart';

class StoryApi {
  Uri index({int? page, int? size, int? location}) {
    return ApiHelper.buildUri(
      endpoint: "stories",
      params: {
        "page": page != null ? page.toString() : "0",
        "size": size != null ? size.toString() : "-1",
        "location": location != null ? location.toString() : "0",
      },
    );
  }

  Uri detail({String? id}) {
    return ApiHelper.buildUri(
      endpoint: "stories/$id",
    );
  }
}

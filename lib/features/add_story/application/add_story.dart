import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/features/add_story/persentation/controller/add_story.dart';
import 'package:status_app/features/stories/persentation/controller/story_index.dart';
import 'package:status_app/pages/home_fragment.dart';

class AddStoryApplication {
  addStory(
      {required BuildContext context,
      required Size size,
      required String description,
      required String fileName,
      required List<int> image,
      required WidgetRef ref,
      double? lon,
      double? lat}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PopScope(
          onPopInvoked: (didPop) => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              height: size.height * 0.3,
              padding: EdgeInsets.all(size.width * 0.03),
              child: Consumer(
                builder: (context, ref, child) {
                  final pagingController = ref.watch(pagingControllerProvider);

                  final response = ref.watch(
                    addStoryControllerProv(
                      AddStoryParams(
                        description: description,
                        fileName: fileName,
                        image: image,
                        lon: lon,
                        lat: lat,
                      ),
                    ),
                  );

                  return response.when(
                    data: (data) {
                      Future.delayed(
                        const Duration(milliseconds: 300),
                        () {
                          AppRoutes.goRouter.pop();
                        },
                      );
                      return const Text("Berhasil Menambahkan Cerita");
                    },
                    error: (error, stackTrace) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * h1,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Text(
                            // error.toString(),
                            "Success",
                            style: TextStyle(
                              fontSize: size.height * p1,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                AppRoutes().clearAndNavigate(AppRoutes.home);

                                pagingController.refresh();

                                ref.invalidate(
                                  storyIndexControllerProv(
                                    const StoryIndexParams(
                                      page: 1,
                                      size: 3,
                                      location: 0,
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Kembali",
                                style: TextStyle(
                                  fontSize: size.height * p1,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Sedang Mengunggah",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * h1,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          const CircularProgressIndicator(),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  addImage({
    required BuildContext context,
    required Size size,
    required Function()? functionGallery,
    required Function()? functionCamera,
  }) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            size.width * 0.06,
            0,
            0,
            0,
          ),
          height: size.height * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: functionGallery,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/picture.png",
                          height: size.width * 0.1,
                          width: size.width * 0.1,
                        ),
                        Gap(size.height * 0.005),
                        Text(
                          "Gallery",
                          style: TextStyle(fontSize: size.height * p1),
                        )
                      ],
                    ),
                  ),
                  Gap(size.width * 0.06),
                  InkWell(
                    onTap: functionCamera,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/camera.png",
                          height: size.height * 0.05,
                          width: size.height * 0.05,
                        ),
                        Gap(size.height * 0.005),
                        Text(
                          "Camera",
                          style: TextStyle(fontSize: size.height * p1),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

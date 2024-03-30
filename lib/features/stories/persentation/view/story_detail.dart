import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/features/stories/domain/stories.dart';
import 'package:status_app/features/stories/persentation/controller/story_detail.dart';

class StoryDetail extends ConsumerWidget {
  const StoryDetail({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final storyDetail =
        ref.watch(storyDetailControllerProv(StoryDetailParams(id: story.id)));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.storyDetail,
          style: TextStyle(
            fontSize: size.height * h1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: storyDetail.when(
        data: (data) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                size.width * 0.03,
                size.height * 0.02,
                size.width * 0.03,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// photo
                  SizedBox(
                    height: size.width,
                    width: size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        data.photoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Gap(size.height * 0.03),

                  /// detail
                  /// account
                  Row(
                    children: [
                      CircleAvatar(
                        radius: size.width * 0.05,
                        child: const Icon(Icons.person),
                      ),
                      Gap(size.width * 0.03),
                      Text(
                        story.name,
                        style: TextStyle(
                          fontSize: size.height * h2,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),

                  /// description
                  Gap(size.height * 0.03),
                  Text(
                    data.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: size.height * p1,
                    ),
                  ),

                  /// lat and lan
                  Gap(size.height * 0.03),
                  // Text(
                  //   "lat : ${data.lat}",
                  //   style: TextStyle(
                  //     fontSize: size.height * p1,
                  //   ),
                  // ),
                  // Gap(size.height * 0.01),
                  // Text(
                  //   "lon : ${data.lon}",
                  //   style: TextStyle(
                  //     fontSize: size.height * p1,
                  //   ),
                  // ),

                  Visibility(
                    visible: data.lat != null && data.lon != null,
                    child: Center(
                      child: SizedBox(
                        width: size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            AppRoutes.goRouter.pushNamed(
                              AppRoutes.map,
                              extra: data,
                            );
                          },
                          child: Text(
                            "Lokasi",
                            style: TextStyle(fontSize: size.height * h3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return const Center(child: Text("Data tidak ditemukan"));
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

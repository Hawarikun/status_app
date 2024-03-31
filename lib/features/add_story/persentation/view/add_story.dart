import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:status_app/core/configs/color.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/core/helper/compressed_image.dart';
import 'package:status_app/features/add_story/application/add_story.dart';
import 'package:status_app/widgets/custom_textformfiel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final imagePathProvider = StateProvider.autoDispose<String?>((ref) => null);

final imageFileProvider = StateProvider.autoDispose<XFile?>((ref) => null);

final descriptionControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);

final latitudeControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());
final longitudeControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());

class AddStory extends StatefulWidget {
  const AddStory({super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, ref, child) {
        final imagePath = ref.watch(imagePathProvider);
        final imageFile = ref.watch(imageFileProvider);
        final descriptionController = ref.watch(descriptionControllerProvider);
        final latitudeController = ref.watch(latitudeControllerProvider);
        final longitudeController = ref.watch(longitudeControllerProvider);

        onGalleryView() async {
          final picker = ImagePicker();

          final pickerFile = await picker.pickImage(
            source: ImageSource.gallery,
          );

          if (pickerFile != null) {
            ref.read(imageFileProvider.notifier).state = pickerFile;
            ref.read(imagePathProvider.notifier).state = pickerFile.path;
          }
        }

        onCameraView() async {
          final picker = ImagePicker();

          final pickerFile = await picker.pickImage(
            source: ImageSource.camera,
          );

          if (pickerFile != null) {
            ref.read(imageFileProvider.notifier).state = pickerFile;
            ref.read(imagePathProvider.notifier).state = pickerFile.path;
          }
        }

        getBytes() async {
          final bytes = await imageFile!.readAsBytes();

          final newBytes = await compressImage(bytes);

          return newBytes;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.addStory,
              style: TextStyle(
                fontSize: size.height * h1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              size.width * 0.03,
              size.height * 0.03,
              size.width * 0.03,
              0,
            ),
            child: Column(
              children: [
                /// add photo
                GestureDetector(
                  onTap: () {
                    if (imagePath == null) {
                      AddStoryApplication().addImage(
                        context: context,
                        size: size,
                        functionGallery: () {
                          AppRoutes.goRouter.pop();
                          onGalleryView();
                        },
                        functionCamera: () {
                          AppRoutes.goRouter.pop();
                          onCameraView();
                        },
                      );
                    }
                    return;
                  },
                  child: Container(
                    height: size.width * 0.5,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                      image: null,
                    ),
                    child: imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(imagePath.toString()),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: size.height * h1,
                                color: Colors.grey,
                              ),
                              Gap(size.width * 0.02),
                              Text(
                                AppLocalizations.of(context)!.addImage,
                                style: TextStyle(
                                  fontSize: size.height * p1,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                  ),
                ),

                Visibility(
                  visible: imagePath != null,
                  child: Column(
                    children: [
                      Gap(size.height * 0.03),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.primary,
                        ),
                        onPressed: () {
                          AddStoryApplication().addImage(
                            context: context,
                            size: size,
                            functionGallery: () {
                              AppRoutes.goRouter.pop();
                              onGalleryView();
                            },
                            functionCamera: () {
                              AppRoutes.goRouter.pop();
                              onCameraView();
                            },
                          );
                        },
                        child: Text(
                          "Ubah Gambar",
                          style: TextStyle(
                            fontSize: size.height * h2,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// add description
                Gap(size.height * 0.03),
                CustomTextFormField(
                  nameController: descriptionController,
                  type: TextInputType.emailAddress,
                  maxLines: 6,
                  radius: 8,
                  hintText: AppLocalizations.of(context)!.description,
                  callBack: (value) {
                    if (value == null || value == "") {
                      return "harus diisi";
                    }

                    return null;
                  },
                ),
                Gap(size.height * 0.03),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            nameController: latitudeController,
                            type: TextInputType.number,
                            hintText: "Latitude",
                            callBack: (p0) {
                              return null;
                            },
                          ),
                          Gap(size.height * 0.01),
                          CustomTextFormField(
                            nameController: longitudeController,
                            type: TextInputType.number,
                            hintText: "Latitude",
                            callBack: (p0) {
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: size.width * 0.02),
                        child: ElevatedButton(
                          onPressed: () {
                            AppRoutes.goRouter.pushNamed(AppRoutes.pickerMap);
                          },
                          child: Text(
                            "Pilih",
                            style: TextStyle(fontSize: size.height * h3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(size.height * 0.05),
                SizedBox(
                  width: size.width,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorApp.primary,
                    ),
                    onPressed: () async {
                      final bytes = await getBytes();

                      // Check if the widget is still mounted before proceeding
                      if (context.mounted) {
                        // Add the story only if the widget is still mounted
                        AddStoryApplication().addStory(
                          context: context,
                          ref: ref,
                          size: size,
                          description: descriptionController.text,
                          fileName: imageFile!.name,
                          image: bytes,
                          lon: double.parse(longitudeController.text),
                          lat: double.parse(latitudeController.text),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.addStory,
                      style: TextStyle(
                        fontSize: size.height * h2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

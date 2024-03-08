import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:status_app/core/configs/color.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:status_app/core/configs/text_size.dart';
import 'package:status_app/core/datas/shared_preferences.dart';
import 'package:status_app/pages/home_fragment.dart';

final currentIndexProvider = StateProvider.autoDispose<int>(
  (ref) => 0,
);

final pageControllerProvider = StateProvider.autoDispose<PageController>(
  (ref) => PageController(),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final currentIndex = ref.watch(currentIndexProvider);
    final pageController = ref.watch(pageControllerProvider);

    List pageOption = [
      const HomeFragment(),
      const Center(
        child: Text("settings"),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Story App",
          style: TextStyle(
            fontSize: size.height * h1,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await LocalPrefsRepository().deleteToken();
              AppRoutes().clearAndNavigate(
                AppRoutes.auth,
              );
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: pageOption.length,
        itemBuilder: (context, index) => pageOption.elementAt(currentIndex),
        onPageChanged: (value) {
          ref.read(currentIndexProvider.notifier).state = value;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          ref.read(currentIndexProvider.notifier).state = value;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: "Home",
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.small(
      //   onPressed: () {},
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: currentIndex == 0 ? true : false,
        child: SizedBox(
          height: size.width * 0.15,
          width: size.width * 0.15,
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: ColorApp.primary,
            ),
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

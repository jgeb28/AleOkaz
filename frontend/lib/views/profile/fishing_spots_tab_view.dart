import 'package:ale_okaz/view_models/profile/fishing_spots_tab_view_model.dart';
import 'package:ale_okaz/widgets/fishing_spot_container.dart';
import 'package:ale_okaz/widgets/my_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:ale_okaz/widgets/my_search_bar.dart';
import 'package:get/get.dart';

class FishingSpotsTab extends StatefulWidget {
  const FishingSpotsTab({super.key});

  @override
  State<FishingSpotsTab> createState() => _FishingSpotsTabState();
}

class _FishingSpotsTabState extends State<FishingSpotsTab> {
  late FishingSpotsTabViewModel viewModel;

  @override
  void initState() {
    Get.delete<FishingSpotsTabViewModel>();
    viewModel = Get.put(FishingSpotsTabViewModel());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<FishingSpotsTabViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel.fetchFishingSpots();
    return Column(
      children: [
        MySearchBar(
          controller: TextEditingController(),
          onChanged: (s) => {},
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MyDropdownMenu(
              sortOptions: viewModel.sortOptions,
              currentSortOption: viewModel.currentSortOption.value,
              onSortOptionChanged: () {},
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Expanded(
          child: Obx( () => ListView(
            children: viewModel.fishingSpots.map((spot) {
              int numberOfPosts = (spot['posts'] is List) ? (spot['posts'] as List).length : 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FishingSpotContainer(
                  fishingSpotId: spot["id"],
                  fishingSpotName: spot["name"],
                  fishCount: numberOfPosts,
                ),
              );
            }).toList(),
          )),
        )
      ],
    );
  }
}

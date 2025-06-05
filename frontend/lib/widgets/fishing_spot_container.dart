import 'package:flutter/material.dart';
import 'package:ale_okaz/consts/colors.dart';
import 'package:get/get.dart'; // Adjust import as needed

class FishingSpotContainer extends StatelessWidget {
  final String fishingSpotId;
  final String fishingSpotName;
  final int fishCount;

  const FishingSpotContainer({
    super.key,
    required this.fishingSpotId,
    required this.fishingSpotName,
    required this.fishCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: offWhiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/spot.jpg', // you could also pass this as a parameter if needed
              height: 110,
              width: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fishingSpotName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text("Liczba złapanych okazów: $fishCount"),
              const SizedBox(height: 6),
              FilledButton(
                onPressed: () {
                  Get.toNamed('/home/$fishingSpotId');
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(180, 40),
                  backgroundColor: buttonBackgroundColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Zobacz",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

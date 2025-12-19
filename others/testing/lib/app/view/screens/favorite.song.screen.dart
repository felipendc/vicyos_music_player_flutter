import 'package:flutter/material.dart';
import 'package:vicyos_music/app/widgets/aurora.bar.dart';

class FavoriteSongsScreen extends StatelessWidget {
  const FavoriteSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(80),
          child: SizedBox(
            width: 40,
            child: const AuroraBar(height: 4),
          ),
        ),
      ),
    );
  }
}

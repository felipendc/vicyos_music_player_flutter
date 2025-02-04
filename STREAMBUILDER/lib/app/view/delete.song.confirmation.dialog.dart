import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_extension.dart';

late bool audioPlayerWasPlaying;

class DeleteSongConfirmationDialog extends StatelessWidget {
  final String songPath;

  const DeleteSongConfirmationDialog({super.key, required this.songPath});
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(0),
      ),
      child: Container(
        color: TColor.bg,
        height: media.height * 0.3, // Adjust the height as needed
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "DELETE FILE FROM DEVICE",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: TColor.org,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Are you sure?",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: TColor.primaryText80,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      label: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: TColor.primaryText80,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: TColor.darkGray,
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton.extended(
                      label: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: TColor.primaryText,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Delete song from device
                        Navigator.pop(context);
                      },
                      backgroundColor: TColor.darkGray,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

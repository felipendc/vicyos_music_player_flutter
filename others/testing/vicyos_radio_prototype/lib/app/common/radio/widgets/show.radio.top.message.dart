import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';

void errorToFetchRadioStationCard(BuildContext context, String radio) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 38,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TColor.focus,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/img/radio/antenna-bars-off-streamline-tabler.png",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      radio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // SizedBox(height: 2),
                    Text(
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "ERROR TO PLAY RADIO STATION",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    // Text(
                    //   textAlign: TextAlign.left,
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    //   "",
                    //   style: TextStyle(color: Colors.white, fontSize: 16),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(
    Duration(seconds: 5),
    () {
      overlayEntry.remove();
    },
  );
}

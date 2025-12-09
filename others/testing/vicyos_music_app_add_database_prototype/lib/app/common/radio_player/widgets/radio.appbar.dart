import 'package:flutter/material.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

AppBar mainRadioPlayerViewAppBar(BuildContext context) {
  return AppBar(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    toolbarHeight: 60,
    elevation: 0,
    automaticallyImplyLeading: false,
    leading: SizedBox(
      width: 45,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          splashRadius: 20,
          icon: Image.asset("assets/img/menu/keyboard_arrow_down.png"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
    centerTitle: true,
    backgroundColor: TColor.bg,
    title: Text(
      AppLocalizations.of(context)!.vicyos_radio,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: TColor.primaryText80,
        fontSize: 23,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 50,
            height: 50,
            child: IconButton(
              splashRadius: 20,
              icon: Image.asset("assets/img/menu/more_horiz.png"),
              onPressed: null,
            ),
          ),
        ),
      ),
    ],
  );
}

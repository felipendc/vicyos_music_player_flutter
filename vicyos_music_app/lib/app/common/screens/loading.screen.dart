import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vicyos_music/app/common/color_palette/color_extension.dart';
import 'package:vicyos_music/app/common/music_player/music.player.functions.and.more.dart';
import 'package:vicyos_music/l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  final FetchingSongs currentStatus;
  const LoadingScreen({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 250,
        ),
        (currentStatus == FetchingSongs.fetching)
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  size: 40,
                ),
              )
            : (currentStatus == FetchingSongs.musicFolderIsEmpty)
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      color: TColor.bg,
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          AppLocalizations.of(context)!
                              .no_songs_have_been_found_in_the_music_folder,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  )
                : (currentStatus == FetchingSongs.noMusicFolderHasBeenFound)
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          color: TColor.bg,
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              AppLocalizations.of(context)!
                                  .there_is_no_music_folder_on_your_device,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      )
                    : (currentStatus == FetchingSongs.permissionDenied)
                        ? Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  child: Container(
                                    color: TColor.bg,
                                    child: Center(
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        AppLocalizations.of(context)!
                                            .no_audio_permission_has_been_granted,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                child: Text(
                                    textAlign: TextAlign.center,
                                    AppLocalizations.of(context)!
                                        .grant_permission),
                                onPressed: () async {
                                  appSettingsWasOpened =
                                      await openAppSettings();
                                },
                              )
                            ],
                          )
                        : Container(
                            color: TColor.bg,
                          )
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR')
  ];

  /// No description provided for @vicyos_radio.
  ///
  /// In en, this message translates to:
  /// **'Vicyos Radio'**
  String get vicyos_radio;

  /// No description provided for @vicyos_music.
  ///
  /// In en, this message translates to:
  /// **'Vicyos Music'**
  String get vicyos_music;

  /// No description provided for @welcome_to.
  ///
  /// In en, this message translates to:
  /// **'Welcome to...'**
  String get welcome_to;

  /// No description provided for @just_a_sec.
  ///
  /// In en, this message translates to:
  /// **'Just a sec...'**
  String get just_a_sec;

  /// No description provided for @no_search_results.
  ///
  /// In en, this message translates to:
  /// **'No search results'**
  String get no_search_results;

  /// No description provided for @streaming_all_capitalized.
  ///
  /// In en, this message translates to:
  /// **'STREAMING'**
  String get streaming_all_capitalized;

  /// No description provided for @prepositionOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get prepositionOf;

  /// No description provided for @the_radio_is_turned_off.
  ///
  /// In en, this message translates to:
  /// **'The radio is turned off'**
  String get the_radio_is_turned_off;

  /// No description provided for @ellipsis.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get ellipsis;

  /// No description provided for @folder_name.
  ///
  /// In en, this message translates to:
  /// **'Folder:'**
  String get folder_name;

  /// No description provided for @add_folder_to_the_current_playlist.
  ///
  /// In en, this message translates to:
  /// **'Add folder to the current playlist'**
  String get add_folder_to_the_current_playlist;

  /// No description provided for @added_to_the_current_playlist.
  ///
  /// In en, this message translates to:
  /// **'Added to the current playlist'**
  String get added_to_the_current_playlist;

  /// No description provided for @play_all_the_songs_from_this_folder.
  ///
  /// In en, this message translates to:
  /// **'Play all the songs from this folder'**
  String get play_all_the_songs_from_this_folder;

  /// No description provided for @playing_all_the_songs_from_this_folder.
  ///
  /// In en, this message translates to:
  /// **'Playing all the songs from this folder'**
  String get playing_all_the_songs_from_this_folder;

  /// No description provided for @add_to_playlist_all_capitalized.
  ///
  /// In en, this message translates to:
  /// **'ADD TO PLAYLIST'**
  String get add_to_playlist_all_capitalized;

  /// No description provided for @import_folder.
  ///
  /// In en, this message translates to:
  /// **'Import folder'**
  String get import_folder;

  /// No description provided for @add_songs.
  ///
  /// In en, this message translates to:
  /// **'Add songs'**
  String get add_songs;

  /// No description provided for @song_name.
  ///
  /// In en, this message translates to:
  /// **'Song Name:'**
  String get song_name;

  /// No description provided for @add_to_play_next.
  ///
  /// In en, this message translates to:
  /// **'Add to Play Next'**
  String get add_to_play_next;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @delete_from_device.
  ///
  /// In en, this message translates to:
  /// **'Delete from device'**
  String get delete_from_device;

  /// No description provided for @clear_playlist_all_capitalized.
  ///
  /// In en, this message translates to:
  /// **'CLEAR PLAYLIST'**
  String get clear_playlist_all_capitalized;

  /// No description provided for @song_preview.
  ///
  /// In en, this message translates to:
  /// **'Song Preview'**
  String get song_preview;

  /// No description provided for @playback_speed_all_capitalized.
  ///
  /// In en, this message translates to:
  /// **'PLAYBACK SPEED'**
  String get playback_speed_all_capitalized;

  /// No description provided for @default_playback_speed.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get default_playback_speed;

  /// No description provided for @delete_from_device_all_capitalized.
  ///
  /// In en, this message translates to:
  /// **'DELETE FILE FROM DEVICE'**
  String get delete_from_device_all_capitalized;

  /// No description provided for @are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get are_you_sure;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete\''**
  String get delete;

  /// No description provided for @search_with_ellipsis.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search_with_ellipsis;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @radio.
  ///
  /// In en, this message translates to:
  /// **'Radio'**
  String get radio;

  /// No description provided for @error_to_play_radio_station_all_capitalized.
  ///
  /// In en, this message translates to:
  /// **'ERROR TO PLAY RADIO STATION'**
  String get error_to_play_radio_station_all_capitalized;

  /// No description provided for @the_song_folder_will_be_displayed_here.
  ///
  /// In en, this message translates to:
  /// **'The song folder will be displayed here...'**
  String get the_song_folder_will_be_displayed_here;

  /// No description provided for @unknown_album.
  ///
  /// In en, this message translates to:
  /// **'Unknown Album'**
  String get unknown_album;

  /// No description provided for @the_playlist_is_empty.
  ///
  /// In en, this message translates to:
  /// **'The playlist is empty'**
  String get the_playlist_is_empty;

  /// No description provided for @unknown_artist.
  ///
  /// In en, this message translates to:
  /// **'Unknown Artist'**
  String get unknown_artist;

  /// No description provided for @added_to_the_playlist.
  ///
  /// In en, this message translates to:
  /// **'Added to the playlist'**
  String get added_to_the_playlist;

  /// No description provided for @added_to_play_next.
  ///
  /// In en, this message translates to:
  /// **'Added to play next'**
  String get added_to_play_next;

  /// No description provided for @repeat_mode_all_capitalized.
  ///
  /// In en, this message translates to:
  /// **'REPEAT MODE:'**
  String get repeat_mode_all_capitalized;

  /// No description provided for @repeating_one.
  ///
  /// In en, this message translates to:
  /// **'Repeating one'**
  String get repeating_one;

  /// No description provided for @playback_is_shuffled.
  ///
  /// In en, this message translates to:
  /// **'Playback is shuffled'**
  String get playback_is_shuffled;

  /// No description provided for @repeating_off.
  ///
  /// In en, this message translates to:
  /// **'Repeating off'**
  String get repeating_off;

  /// No description provided for @repeating_all.
  ///
  /// In en, this message translates to:
  /// **'Repeating all'**
  String get repeating_all;

  /// No description provided for @no_songs_have_been_found_in_the_music_folder.
  ///
  /// In en, this message translates to:
  /// **'No songs have been found in the music folder.'**
  String get no_songs_have_been_found_in_the_music_folder;

  /// No description provided for @there_is_no_music_folder_on_your_device.
  ///
  /// In en, this message translates to:
  /// **'There is no music folder on your device.'**
  String get there_is_no_music_folder_on_your_device;

  /// No description provided for @no_audio_permission_has_been_granted.
  ///
  /// In en, this message translates to:
  /// **'No permission to access\nthe music folder has been granted.'**
  String get no_audio_permission_has_been_granted;

  /// No description provided for @grant_permission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grant_permission;

  /// No description provided for @deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deleted_successfully;

  /// No description provided for @removed_from_the_playlist.
  ///
  /// In en, this message translates to:
  /// **'Removed from the playlist!'**
  String get removed_from_the_playlist;

  /// No description provided for @single_shared_file.
  ///
  /// In en, this message translates to:
  /// **'This file was shared via the Vicyos Music app.'**
  String get single_shared_file;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'All Songs'**
  String get songs;

  /// No description provided for @all_songs.
  ///
  /// In en, this message translates to:
  /// **'All Songs'**
  String get all_songs;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @add_to_favorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get add_to_favorites;

  /// No description provided for @remove_from_favorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get remove_from_favorites;

  /// No description provided for @delete_a_playlist.
  ///
  /// In en, this message translates to:
  /// **'Delete a playlist'**
  String get delete_a_playlist;

  /// No description provided for @what_to_do.
  ///
  /// In en, this message translates to:
  /// **'What to do?'**
  String get what_to_do;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @this_name_has_already_been_used.
  ///
  /// In en, this message translates to:
  /// **'This name is already in use'**
  String get this_name_has_already_been_used;

  /// No description provided for @please_try_another_one.
  ///
  /// In en, this message translates to:
  /// **'Please try another one'**
  String get please_try_another_one;

  /// No description provided for @create_a_playlist_text_field_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. The best ones...'**
  String get create_a_playlist_text_field_hint;

  /// No description provided for @new_playlist.
  ///
  /// In en, this message translates to:
  /// **'New playlist'**
  String get new_playlist;

  /// No description provided for @choose_a_name.
  ///
  /// In en, this message translates to:
  /// **'Choose a name:'**
  String get choose_a_name;

  /// No description provided for @choose_a_playlist.
  ///
  /// In en, this message translates to:
  /// **'Choose a playlist'**
  String get choose_a_playlist;

  /// No description provided for @playlist_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Playlist deleted successfully!'**
  String get playlist_deleted_successfully;

  /// No description provided for @playlist_created_successfully.
  ///
  /// In en, this message translates to:
  /// **'Playlist created successfully!'**
  String get playlist_created_successfully;

  /// No description provided for @playlist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @rename_this_playlist.
  ///
  /// In en, this message translates to:
  /// **'Rename this playlist'**
  String get rename_this_playlist;

  /// No description provided for @delete_this_playlist.
  ///
  /// In en, this message translates to:
  /// **'Delete this playlist'**
  String get delete_this_playlist;

  /// No description provided for @rename_playlist.
  ///
  /// In en, this message translates to:
  /// **'Rename playlist'**
  String get rename_playlist;

  /// No description provided for @choose_a_new_name.
  ///
  /// In en, this message translates to:
  /// **'Choose a new name:'**
  String get choose_a_new_name;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @playlist_renamed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Renamed successfully!'**
  String get playlist_renamed_successfully;

  /// No description provided for @add_to_a_playlist.
  ///
  /// In en, this message translates to:
  /// **'Add to a playlist'**
  String get add_to_a_playlist;

  /// No description provided for @added_successfully.
  ///
  /// In en, this message translates to:
  /// **'Added successfully'**
  String get added_successfully;

  /// No description provided for @create_a_new_playlist.
  ///
  /// In en, this message translates to:
  /// **'Create a new playlist'**
  String get create_a_new_playlist;

  /// No description provided for @removed_from_this_playlist.
  ///
  /// In en, this message translates to:
  /// **'Remove from this playlist'**
  String get removed_from_this_playlist;

  /// No description provided for @create_a_playlist.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Create a playlist} =1{Create a new playlist} other{Create a new playlist}}'**
  String create_a_playlist(num count);

  /// No description provided for @total_of_playlist.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 playlists} =1{Total: 1 playlist} other{Total: {count} playlists}}'**
  String total_of_playlist(num count);

  /// No description provided for @playlist_total_of_songs.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{songs} =1{song} other{songs}}'**
  String playlist_total_of_songs(num count);

  /// No description provided for @total_of_songs.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Total: O songs} =1{Total: 1 song} other{Total: {count} songs}}'**
  String total_of_songs(num count);

  /// No description provided for @multiple_shared_files.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{} =1{This file was shared using the Vicyos Music app.} other{These {count} files were shared using the Vicyos Music app.}}'**
  String multiple_shared_files(num count);

  /// No description provided for @number_of_songs_in_folder.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No songs} =1{1 song} other{{count} songs}}'**
  String number_of_songs_in_folder(num count);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

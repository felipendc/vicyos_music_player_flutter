### Vicyos Music App

A Flutter application that allows users to `play audio files from local storage` and listen to `radio streamings`.

### Screenshots

Basic screenshots of the app to give users a visual preview of the Vicyos Music Player interface.

<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/1.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/15.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/permission.png">


 <br />
 
### What motivated me to create the Vicyos Music app?  <br />
- `Vicyos Music` was inspired by the features of `Oto Music` and `Miui Music version 5.3.37i`. <br />
- The main reason I decided to create the Vicyos Music app was my need for a Playback Speed feature  <br />
with a step size of 0.1x instead of the 0.5x found in most apps.  <br />
- `As I'm learning English`, having a Playback Speed with a `step size of 0.1x` allows me to slow down <br />
some podcasts `more precisely` for practicing English Listening.

 <br />

### Vicyos Music app related links:

- Video demonstration: `https://youtu.be/kRfaoKFbTm4`
- How to grant permissions: `https://youtube.com/shorts/eTfI_sFM0Xc?feature=share`
- Download the Vicyos Music Apk: `https://github.com/felipendc/vicyos_music_player_flutter/releases`

 <br />
 
### Features

- Display all the folders containing audio files in '/storage/emulated/0/Music/'.
- Dark UI based on [CodeForAny - Music App Tutorial](https://youtube.com/playlist?list=PLzcRC7PA0xWRXGSJZOyD5_SXyGIRt6VFr)
- Animations to enhance the user experience.
- Play a song from a folder, play all the from a folder, or add a folder to the current playlist.
- Play, pause, skip, rewind 5 or go forward 5 seconds, control volume from the player screen, or even seek to a specific part of the song.
- Search for songs, add to play next, delete files, share songs, preview a song, and more!
- Minimalistic and intuitive user interface.
- Radio stations: `A small selection of simple stations` that I frequently listen to in Portuguese and English.

### Getting Started

These instructions will help you get a copy of this project up and running on your local machine for development and testing purposes.

<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/how-it-should-look-like_01.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/how-it-should-look-like_02.png">

### This project is currently compatible with:

#### Java 21 (LTS):

- Java Version: `21.0.9+10`
- Azul Zulu: `21.46.19`
- Link: https://www.azul.com/downloads/?version=java-21-lts&os=windows&architecture=x86-64-bit&package=jdk#zulu

<!--
> If you run flutter doctor and get this error:  <br />
> [!] Android Studio, X Unable to determine bundled Java version. <br />
>
> To fix it, got to `project_folder/android/`, then open a cmd window and run: <br />
> flutter clean <br />
> gradlew wrapper --gradle-version 8.10.2 --distribution-type bin <br />
-->

#### Android Studio:

- Android Studio Otter 2 Feature Drop | `2025.2.2 December 4, 2025`
- ChromeOS: `android-studio-2025.2.2.7-cros.deb (1.2 GB)`
- Mac (Apple Silicon): `android-studio-2025.2.2.7-mac_arm.dmg (1.5 GB)`
- Mac (Intel): `android-studio-2025.2.2.7-mac.dmg (1.5 GB)`
- Windows (64-bit): `android-studio-2025.2.2.7-windows.exe (1.4 GB)`
- Linux: `android-studio-2025.2.2.7-linux.tar.gz (1.5 GB)`
- LINK: https://developer.android.com/studio/archive
- Flutter plugin for Android Studio: https://plugins.jetbrains.com/plugin/9212-flutter

#### Flutter 3.38.5:

- Channel: `Stable`
- Flutter version: `3.38.5 x64`
- Dart version: `3.10.4 (stable) for "windows_x64"`
- File name: `flutter_windows_3.38.5-stable.zip`
- LINK: https://docs.flutter.dev/release/archive
- How to install Flutter and set it up: https://flutter.dev/docs/get-started/install

#### Git for Windows:

- Git for Windows: https://gitforwindows.org/

#### Visual Studio Code:

- Visual Studio - develop Windows apps (Visual Studio Community): https://visualstudio.microsoft.com/pt-br/

#### VS Code:

- Visual Studio Code: https://code.visualstudio.com/
- Flutter extension for VS Code: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

##

### Downloading this project

Shallow clone this repository: `git clone --depth 1 https://github.com/felipendc/vicyos_music_player_flutter.git` <br />
Navigate to the project directory: `cd vicyos_music_player_flutter/vicyos_music_app` <br />


### Installing or Compiling


0. Open VS Code Editor or Android Studio (recommended)
1. Run `flutter clean` to make a clean build and avoid potential build errors.
2. Run `flutter pub get` to install the required dependencies.
3. Connect your device to the PC or start an emulator.
4. Run `flutter run` to launch the app in debug mode.
5. Or better yet! Build the App APK in release mode, the app will be much smoother: `flutter clean; flutter pub get; flutter build apk --release`
6. Or just double click the file `BUILD_APP_WITH_WINDOWS.bat` if you are running Windows.
7. The app will be built in `{projectDir}/build/app/outputs/flutter-apk/vicyos_music_app_v{version}_release.apk"`
8. If the app won't list the audio folders once you open it up, make sure to grant permissions to acess and read the media files in the music folder.
9. Make sure to disable "MIUI battery optimisations" otherwise, MIUI will force stop the player "when/while" you're listening to a song with the app in the background or when the screen is locked or turned off.

### Dependencies

This project uses the following dependencies:

- `audioplayers: 6.5.1` - A Flutter plugin to play multiple simultaneously audio files, works for Android, iOS, Linux, macOS, Windows, and web.
- `just_audio: 0.10.5` - A powerful audio player for Flutter applications.
- `audio_session: 0.2.2` Sets the iOS audio session category and Android audio attributes for your app, and manages your app's audio focus, mixing and ducking behaviour.
- `just_audio_background: 0.0.1-beta.17` An add-on for just_audio that supports background playback and media notifications
- `audio_service: 0.18.18` Flutter plugin to play audio in the background while the screen is off
- `provider: 6.1.2` A wrapper around InheritedWidget to make them easier to use and more reusable.
- `path_provider: 2.1.3` - Provides access to the device's file system paths.
- `path: 1.9.0` - Provides utilities for handling file and directory paths.
<!-- - `media_info: 0.12.0+2` Platform services exposed to Flutter apps. -->
- `sleek_circular_slider: 2.0.1` A highly customizable circular slider/progress bar & spinner for Flutter.
<!-- - `flutter_media_metadata: 1.0.0+1` A Flutter plugin to read metadata of media files. -->
- `volume_controller: 3.4.0` A Flutter volume plugin for ios and android control system volume.
- `file_picker: 10.3.7` A package that allows you to use a native file explorer to pick single or multiple absolute file paths, with extension filtering support.
- `permission_handler: 11.3.1` - Handles runtime permissions for accessing device features.
- `flutter_native_splash: 2.4.7` Customize Flutter's default white native splash screen with background color and splash image.
- `music_visualizer: 1.0.6` This plugin help developers to show a music wave through animation.
<!-- - `get: 4.6.6` Open screens/snackbars/dialogs without context, manage states and inject dependencies easily with GetX. -->
- `uuid: 4.5.1` RFC4122 (v1, v4, v5, v6, v7, v8) UUID Generator and Parser for Dart.
- `flutter_launcher_icons: 0.14.3` A package which simplifies the task of updating your Flutter app's launcher icon.
- `marquee: 2.3.0` A Flutter widget that scrolls text infinitely. Provides many customizations including custom scroll directions, durations, curves as well as pauses after every round.
- `share_plus 12.0.1` Flutter plugin for sharing content via the platform share UI, using the ACTION_SEND intent on Android and UIActivityViewController on iOS.
- `flutter_media_delete 1.0.1` TA Flutter plugin designed for deleting media files using scoped storage on Android versions Q (API 29) and above.
- `loading_animation_widget 1.3.0` Loading animation or loading spiner or loader. It's used to show loading animation when the app is in loading state or something is processing for uncertain time.
- `http: 1.6.0` - A composable, multi-platform, Future-based API for HTTP requests..
- `sqflite: 2.4.2` - Flutter plugin for SQLite, a self-contained, high-reliability, embedded, SQL database engine.
- `flutter_sound: 9.30.0` - Flutter Sound is a library package allowing you to play and record audio for : iOS; Android; Web.

### Submit a pull request

1. Fork the project.
2. Create your feature branch: `git checkout -b feature/new-feature`
3. Commit your changes: `git commit -am 'Add a new feature'`
4. Push to the branch: `git push origin feature/new-feature`
5. Open a pull request.

### Acknowledgments

- The Dark UI theme is based on [CodeForAny - Music App Tutorial](https://youtube.com/playlist?list=PLzcRC7PA0xWRXGSJZOyD5_SXyGIRt6VFr)
- Shoutout to the Flutter community for their support and resources.
- [svgrepo:](https://www.svgrepo.com/), [flaticon:](https://www.flaticon.com/), [Google Fonts:](https://fonts.google.com/icons), and [icons8:](https://icons8.com.br/) for the Icons.
- [logrocket:](https://blog.logrocket.com/flutter-slider-widgets-deep-dive-with-examples/) for the volume slider theme.

### Vicyos Music Player Screenshots
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/radio_1.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/radio_2.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/radio_3.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/radio_4.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/15.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/11.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/12.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/13.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/6.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/2.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/3.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/4.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/5.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/7.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/8.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/10.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/read_banners/14.png">

<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/40.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/41.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/42.png">

<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/1.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/2.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/33.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/3.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/4.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/5.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/6.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/7.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/8.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/9.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/10.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/11.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/12.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/13.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/14.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/15.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/16.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/17.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/18.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/19.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/20.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/21.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/22.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/23.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/24.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/25.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/26.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/27.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/28.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/29.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/30.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/31.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/32.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/33.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/34.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/35.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/36.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/37.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/38.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/others/SCREENSHOTS_DEMO/SCREENSHOTS/V3.0.9_tablet_mode/39.png">

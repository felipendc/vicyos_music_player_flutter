### Vicyos Music App

A Flutter music streaming application that allows users to play audio files from local storage.

### Screenshots

Basic screenshots of the app to give users a visual preview of the Vicyos Music Player interface.


<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/SCREENSHOTS_DEMO/main_demo.png">


### Recent screenshots of the Vicoys Music app:
- You can find them here: `https://github.com/felipendc/vicyos_music_player_flutter/tree/main/SCREENSHOTS_DEMO/RECENT_SCREENSHOTS`


### Features

- Display all the folders containing audio files in '/storage/emulated/0/Music/'.
- Dark UI based on [CodeForAny - Music App Tutorial](https://youtube.com/playlist?list=PLzcRC7PA0xWRXGSJZOyD5_SXyGIRt6VFr)
- Animations to enhance the user experience.
- Play a song from a folder, play all the from a folder, or add a folder to the current playlist.
- Play, pause, skip, rewind 5 or go forward 5 seconds, control volume from the player screen, or even seek to a specific part of the song.
- Minimalistic and intuitive user interface.

## 

### Getting Started

These instructions will help you get a copy of this project up and running on your local machine for development and testing purposes.


<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/SCREENSHOTS_DEMO/how-it-should-look-like.png">

### This project is currently compatible with:

#### Android Studio:
- Android Studio Ladybug Feature Drop | `2024.2.2 RC 2 December 16, 2024`
- ChromeOS: `android-studio-2024.2.2.12-cros.deb (1.0 GB)`
- Mac (Apple Silicon): `android-studio-2024.2.2.12-mac_arm.dmg (1.3 GB)`
- Mac (Intel): `android-studio-2024.2.2.12-mac.dmg (1.3 GB)`
- Windows (64-bit): `android-studio-2024.2.2.12-windows.exe (1.2 GB)`
- LINK: https://developer.android.com/studio/archive
- Flutter plugin for Android Studio: https://plugins.jetbrains.com/plugin/9212-flutter



#### Flutter 3.27.3:

- Flutter version: `3.27.3 x64`
- Dart version: `3.6.1 (stable) (Tue Jan 7 09:50:00 2025 -0800) on "windows_x64"`
- File name:  `flutter_windows_3.27.3-stable.zip` 
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

Clone this repository: `git clone https://github.com/felipendc/vicyos_music_player_flutter.git` <br />
Navigate to the project directory: `cd vicyos_music_player_flutter` <br />
<!-- Choose the one you want "GetX" or "StreamBuilder" UI state management. <br /> -->

### Installing or Compiling

0. Open VS Code Editor
1. Run `flutter clean` to make a clean build and avoid potential build errors.
2. Run `flutter pub get` to install the required dependencies.
3. Connect your device to the PC or start an emulator.
4. Run `flutter run` to launch the app in Debug Mode.
5. Or better yet! Build the App APK: `flutter clean; flutter pub get; flutter build apk --release`
6. or Just double click the file `BUILD_APP_WITH_WINDOWS.bat` if you are running Windows.
7. If the app won't list the audio folders once you open it up, make sure to grant permissions to acess and read the media files in the music folder.
8. Make sure to disable "MIUI battery optimisations" otherwise, MIUI will force stop the player "when/while" you're listening to a song with the app in the background or when the screen is locked or turned off.

### Dependencies

This project uses the following dependencies:

- `audioplayers: 6.1.1` - A Flutter plugin to play multiple simultaneously audio files, works for Android, iOS, Linux, macOS, Windows, and web.
- `just_audio: 0.9.46` - A powerful audio player for Flutter applications.
- `audio_session: 0.1.25` Sets the iOS audio session category and Android audio attributes for your app, and manages your app's audio focus, mixing and ducking behaviour.
- `just_audio_background: 0.0.1-beta.15` An add-on for just_audio that supports background playback and media notifications
- `audio_service: 0.18.17` Flutter plugin to play audio in the background while the screen is off
- `provider: 6.1.2` A wrapper around InheritedWidget to make them easier to use and more reusable.
- `path_provider: 2.1.3` - Provides access to the device's file system paths.
- `path: 1.9.0` - Provides utilities for handling file and directory paths.
<!-- - `media_info: 0.12.0+2` Platform services exposed to Flutter apps. -->
- `sleek_circular_slider: 2.0.1` A highly customizable circular slider/progress bar & spinner for Flutter.
<!-- - `flutter_media_metadata: 1.0.0+1` A Flutter plugin to read metadata of media files. -->
- `volume_controller: 3.2.0` A Flutter volume plugin for ios and android control system volume.
- `file_picker: 8.3.1` A package that allows you to use a native file explorer to pick single or multiple absolute file paths, with extension filtering support.
- `permission_handler: 11.3.1` - Handles runtime permissions for accessing device features.
- `flutter_native_splash: 2.4.1` Customize Flutter's default white native splash screen with background color and splash image.
- `music_visualizer: 1.0.6` This plugin help developers to show a music wave through animation.
<!-- - `get: 4.6.6` Open screens/snackbars/dialogs without context, manage states and inject dependencies easily with GetX. -->
- `uuid: 4.4.2` RFC4122 (v1, v4, v5, v6, v7, v8) UUID Generator and Parser for Dart.
- `flutter_launcher_icons: 0.14.3` A package which simplifies the task of updating your Flutter app's launcher icon.
- `marquee: 2.3.0` A Flutter widget that scrolls text infinitely. Provides many customizations including custom scroll directions, durations, curves as well as pauses after every round.
- `share_plus 10.1.4` Flutter plugin for sharing content via the platform share UI, using the ACTION_SEND intent on Android and UIActivityViewController on iOS.
- `flutter_media_delete 1.0.1` TA Flutter plugin designed for deleting media files using scoped storage on Android versions Q (API 29) and above.
- `loading_animation_widget 1.3.0` Loading animation or loading spiner or loader. It's used to show loading animation when the app is in loading state or something is processing for uncertain time.


### Submit a pull request
1. Fork the project.
2. Create your feature branch: `git checkout -b feature/new-feature`
3. Commit your changes: `git commit -am 'Add a new feature'`
4. Push to the branch: `git push origin feature/new-feature`
5. Open a pull request.



### Acknowledgments

- The Dark UI theme is based on [CodeForAny - Music App Tutorial](https://youtube.com/playlist?list=PLzcRC7PA0xWRXGSJZOyD5_SXyGIRt6VFr)
- Shoutout to the Flutter community for their support and resources.
- [svgrepo:](https://www.svgrepo.com/) and [flaticon:](https://www.flaticon.com/) for the Icons. 
- [logrocket:](https://blog.logrocket.com/flutter-slider-widgets-deep-dive-with-examples/) for the volume slider theme.

### Vicyos Music Player Screenshots 

<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/SCREENSHOTS_DEMO/main_demo.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/SCREENSHOTS_DEMO/demo_1.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/SCREENSHOTS_DEMO/demo_2.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/SCREENSHOTS_DEMO/demo_3.png">
<img src="https://github.com/felipendc/vicyos_music_player_flutter/blob/main/SCREENSHOTS_DEMO/demo_4.png">


@echo off
flutter clean && flutter pub get -v && flutter build apk --release -v && pause
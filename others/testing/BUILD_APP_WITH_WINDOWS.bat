@echo off
flutter clean && flutter pub get && flutter build apk -v --release && pause
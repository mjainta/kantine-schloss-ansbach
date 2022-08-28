# kantine-schloss-ansbach

![Build Status - master](https://github.com/mjainta/kantine-schloss-ansbach/actions/workflows/android-release.yml/badge.svg?branch=master)

## Run tests

Unit tests:
```bash
cd app/
flutter test --dart-define=FB_API_ACCESS_TOKEN=123abc
```

Integration tests:
```bash
cd app/
flutter test integration_test/green_path_test.dart -d "emulator-5554"
```

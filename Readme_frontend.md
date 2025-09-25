# Introduction to Gymnastics Scoring Frontend

The frontend uses the Flutter framework and is designed with Dart.
 Mainly tested on the Android platform. Some features are not available on the Web side.

## Dependency Information

- Flutter version: >= 3.7.7
- Android SDK: Android 13.0 (Tiramisu), API Level 33, downloaded via Android Studio.

## Directory Structure

```
|-- assets: Stores fonts, image files
|-- ios: Cross-platform configuration files, can be ignored for now
|-- android:
|-- windows:
|-- web:
|   |-- lib:
        |   |-- pages: Definition of each page. Since there are many windows, it is recommended to organize folders by window hierarchy in the requirements
        |   |-- utils: Defines helper functions
        |   |-- widgets: Defines reusable components
        |-- main.dart: Program entry point
        |-- theme.dart: Defines color styles
|   |-- test: Test files
|-- pubspec.yaml: Configuration file, where you add dependencies, modify folder structure, etc.

```

- ### Recommended

  Manage environments separately for each project in the IDE (IDE usually has project settings). Try not to use a global environment. In other words, just download Flutter and JDK packages to a location—no need to set environment variables.

  ### Flutter Installation + Dart Installation

  - See Flutter installation guide or CSDN blog
  - Windows version must be higher than Win10. Mac not tested, but should work.
  - In Android Studio, download Dart and Flutter plugins, install Android SDK.
  - `flutter doctor` must pass all checks.
  - Dart SDK is located in `flutter/bin/cache`.
  - `cmd-tool` must be manually installed in **Android Studio → Tools → SDK Manager**.
  - AMD CPUs need SVM enabled in BIOS.

- ### Java Installation

  - Install Java 11 and set `JAVA_HOME` to it.
  - In IDEA, separately set up JDK 1.8 because the backend uses JDK 1.8 (you can download with one click in IDEA). Java 11 is used for Android system.
  - IDEA requires the Pro version.
  - IDEA must specify the project JDK.
  - Maven can use mirrors, or not—it’s optional.

### Flutter Runtime Issues

- **Gradle task assembleDebug failed**: https://blog.csdn.net/qq_55660255/article/details/135239700

- Gradle and Java version mismatch: use `flutter doctor --verbose` to check Java version. See Gradle compatibility to choose the correct Gradle version. Located in `android/gradle/wrapper/gradle-wrapper.properties`.

- If possible, continue to use Flutter 3.7.10 + Android SDK 33. Versions that are too high may cause errors.

- This project’s Gradle requires Java 11, so manually change `JAVA_HOME`.

- A key must be generated manually:

  ```
  keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
  ```

  Then enter `vipa404`.
# Gymnastics Scoring System

This project is a **full-stack application** designed for managing and scoring gymnastics competitions.
 It consists of two main parts:

- **Backend** – built with Spring Boot (Java)
- **Frontend** – built with Flutter (Dart), primarily tested on Android

------

## Features

- Manage competitions, athletes, and scores
- User-friendly mobile frontend (Android-first)
- Scalable backend with RESTful APIs
- Cross-platform support (mobile, web, desktop – limited features on non-Android)

------

## Technology Stack

### Backend

- **Framework:** Spring Boot `2.3.1.RELEASE`
- **Language:** Java 8
- **Build Tool:** Maven
- **Database Access:** MyBatis (Mapper layer)

### Frontend

- **Framework:** Flutter `>=3.7.7`
- **Language:** Dart
- **Platform Tested:** Android 13.0 (Tiramisu), API Level 33
- **Other Platforms:** iOS, Web, Windows (partial support)

------

## Project Structure

### Backend

```
src/main/java/com/vipa/scoring
│-- controller   # API endpoints (frontend-backend logic)
│-- entity       # Entity definitions (match DB fields)
│-- mapper       # Database operations (SQL)
│-- service      # Business logic
│-- utils        # Utility classes
│-- ScoringApplication.java  # Main entry point
```

### Frontend

```
assets/          # Fonts, images
lib/
│-- pages        # UI pages (organized by window hierarchy)
│-- utils        # Helper functions
│-- widgets      # Reusable components
│-- main.dart    # Application entry point
│-- theme.dart   # Color styles
test/            # Test files
pubspec.yaml     # Flutter dependencies
```

------

## Getting Started

### 1. Backend Setup

1. Make sure you have:

   - **Java 8**
   - **Maven**

2. Navigate to the backend folder.

3. Run the project:

   ```bash
   mvn spring-boot:run
   ```

4. The backend will start at `http://localhost:8080`.

------

### 2. Frontend Setup

1. Install **Flutter (>=3.7.7)** via [Flutter installation guide](https://docs.flutter.dev/get-started/install).

2. Make sure Android SDK (API Level 33) is installed via Android Studio.

3. Navigate to the frontend folder.

4. Get dependencies:

   ```bash
   flutter pub get
   ```

5. Run the app on Android:

   ```bash
   flutter run
   ```

------

## Usage

- Start the **backend** first (`http://localhost:8080`).
- Launch the **frontend app** (preferably on Android).
- Use the app to manage competitions, add athletes, and record scores in real time.
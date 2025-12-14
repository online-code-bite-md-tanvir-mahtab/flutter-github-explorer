# Flutter GitHub Explorer

A production-style Flutter application that explores the top Flutter
repositories on GitHub with **offline-first architecture**.

## Features
- GitHub Search API integration
- Offline browsing with Hive cache
- Persistent sorting (stars / last updated)
- Clean Architecture + Riverpod
- Cached images for performance
- Pull-to-refresh support

## Architecture
This project follows Clean Architecture:
- **Domain**: Business logic & entities
- **Data**: API + local persistence
- **Presentation**: Riverpod-driven UI

## Why Offline-First?
The app always serves cached data first, ensuring usability even with
poor or no internet connection.

## How to Run
```bash
flutter pub get
flutter run

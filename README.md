# Zyromate Field Staff App

Production-quality Flutter mobile application for field staff **attendance** and **route tracking**, built from the [Figma design](https://www.figma.com/design/7pVYik98AaBWQNlHhxYqJt/002?node-id=320-2257).

## Features

- Splash with auth check (SharedPreferences)
- Login & registration
- Dashboard with Mark In / Mark Out (GPS + permissions)
- Apply Leave & Leave List with filters
- Route list & map (polyline, Mark In/Out markers)
- MVVM + Provider, repository pattern, Dio networking

## Architecture

```
lib/
├── core/          # theme, constants, network, routes, config
├── models/
├── services/
├── repositories/
├── viewmodels/
├── views/
├── widgets/
└── utils/
```

## API Base URL

`https://test.zyromate.com/api/`

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/user-login` | Login |
| POST | `/register` | Registration |
| GET | `/attendance/status` | Attendance status |
| POST | `/attendance/mark` | Mark in/out |
| POST | `/apply-leave` | Apply leave |
| POST | `/leaves` | Leave list |
| GET | `/attendance/route-list` | Route history |

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Android Studio / Xcode for device builds

### Setup

```bash
cd field_staff_app
flutter pub get
```

### Run

```bash
flutter run
```

### Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## Google Maps (optional)

Without a key, the map screen uses **OpenStreetMap** via `flutter_map`.

To enable Google Maps:

1. Create an API key in [Google Cloud Console](https://console.cloud.google.com/google/maps-apis).
2. **Android**: set `YOUR_GOOGLE_MAPS_API_KEY` in `android/app/src/main/AndroidManifest.xml`.
3. **iOS**: add `GMSServices.provideAPIKey("YOUR_KEY")` in `ios/Runner/AppDelegate.swift`.
4. Run with: `flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_key`

## Design Tokens (from Figma)

| Token | Value |
|-------|-------|
| Background | `#F1F7F7` |
| Primary dark | `#042222` |
| Primary green | `#03624C` |
| Text secondary | `#7D7D7D` |
| Leave accent | `#D4C200` |
| Font | Inter (system fallback) |
| Card radius | 7–15px |
| Button radius | 20px |

## Screen Flow

```
Splash → (logged in?) → Dashboard
                      → Login → Register
Dashboard → Apply Leave → Leave List
         → Route List → Route Map (after Mark In + Out)
```

## Packages

- `provider` — state management
- `dio` — HTTP client
- `shared_preferences` — local session
- `geolocator` + `permission_handler` — GPS
- `intl` — dates
- `google_maps_flutter` + `flutter_map` — maps

## License

Proprietary — assessment / demo project.

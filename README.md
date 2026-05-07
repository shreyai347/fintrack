# FinTrack Pro — Offline Edition

## Architecture decisions

- Flutter + Riverpod (Notifier pattern) chosen over BLoC for lower boilerplate while maintaining clean repository separation
- Drift (SQLite) chosen over Hive for foreign key support and complex queries required by budget + recurring features
- MVVM-style: model / repository / viewmodel / view per feature
- CustomPainter for all charts — no chart library dependencies
- No internet dependency — fully offline, zero network packages

## Folder structure

```
lib/
├── core/
│   ├── config/
│   ├── constants/
│   ├── services/
│   │   ├── biometric/
│   │   ├── camera/
│   │   ├── database/tables/
│   │   ├── export/
│   │   ├── storage/
│   │   └── work/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── budget/
│   ├── dashboard/
│   ├── export/
│   ├── receipt/
│   ├── settings/
│   └── transactions/
├── generated/database/
├── l10n/
├── ui/
├── fintrack_app.dart
└── main.dart
```

*(Full flat file list: run `Get-ChildItem -Path lib -Recurse -File -Filter "*.dart"` from the project root.)*

## Setup instructions

1. Flutter 3.x required (tested on 3.29+)
2. Run: `flutter pub get`
3. Run: `dart run build_runner build`
4. Run: `flutter gen-l10n`
5. Run: `flutter run`

## Running tests

`flutter test`

## Building APK

`flutter build apk --release --target-platform android-arm64`

If the build fails with *non-constant IconData* / tree-shaking icons (dynamic category icons), use:

`flutter build apk --release --target-platform android-arm64 --no-tree-shake-icons`

APK location: `build/app/outputs/flutter-apk/app-release.apk`

If Gradle reports Kotlin incremental cache errors across different drive roots, run `flutter clean` and retry the build.

## Offline verification

Enable airplane mode on device before launching. All features work without internet:

- Add / edit / delete transactions
- View dashboard charts
- Set budgets
- Scan receipts (camera works offline)
- Export CSV / JSON

## Known limitations

- Receipt camera not testable on emulator (use real device)
- WorkManager background job minimum interval is 15 minutes on Android (even if registered as 24h — OS controls exact timing)
- Biometric requires hardware support on device

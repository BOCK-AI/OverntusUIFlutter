# Orventus (Flutter web)

A lightweight web clone inspired by Uber's public site, renamed to **Orventus** everywhere per your request.
Includes a landing page, login, and responsive dashboards for Web and Mobile targets.
Most buttons and cards are wired to do something useful (navigate, dialogs, snackbars).

## Run

```bash
flutter config --enable-web
flutter pub get
flutter run -d chrome
```

## Structure

- `lib/pages/home_page.dart` — Landing page sections (Ride, Drive, Business, About)
- `lib/pages/login_page.dart` — Login form (uses your submit flow and redirects to dashboards)
- `lib/pages/dashboard_web.dart` — Web dashboard
- `lib/pages/dashboard_mobile.dart` — Mobile dashboard
- `lib/widgets/*` — Reusable UI pieces

## Notes

- This is a demo; map, payments, and real auth are simulated.
- Replace dialogs with real integrations as needed.

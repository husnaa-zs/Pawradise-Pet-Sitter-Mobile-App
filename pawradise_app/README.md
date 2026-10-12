# Pawradise (Flutter)

A cat community mobile app: adopt cats, book trusted sitters, and book clinic appointments.
Mock data stands in for a backend, so the whole system works offline.

## Run it
1. Install Flutter (https://docs.flutter.dev/get-started/install).
2. In this folder run:
   ```
   flutter create .        # generates android/ ios/ etc. (keeps lib/ and pubspec.yaml)
   flutter pub get
   flutter run
   ```
3. Optional: `flutter test` runs the state tests.
(`google_fonts` downloads Montserrat/Quicksand the first time, so the first run needs internet.)

## How the system works
```
Welcome (pick role: Owner / Sitter)
   -> Login or Sign up (mock auth, form validation)
      -> Shell: bottom navigation
          Home     role-aware dashboard (owner: popular cats | sitter: booking requests with accept/decline)
          Sitters  search + filters -> Book Sitter (pick date + services, total price) -> saved booking
          Adopt    search + category filter -> Cat detail -> Adopt request, favourites
          Clinic   pick date + doctor + free slot -> saved appointment
          Profile  edit personal info, see all bookings / appointments / adoption requests, log out
```
All user actions are stored in `AppState` (lib/state.dart), a `ChangeNotifier` shared through an
`InheritedNotifier` (`AppScope`), so every screen updates automatically.

## Structure
```
lib/main.dart            app entry + AppScope
lib/theme.dart           colours (Pawradise palette), Montserrat + Quicksand
lib/data.dart            models + mock sitters, cats, doctors, services
lib/state.dart           AppState (role, auth, favourites, bookings, appointments, requests)
lib/widgets.dart         CatFace + landscape illustrations (drawn in code), buttons, fields, CatCard
lib/screens/             auth, shell (home), sitters, adoption, clinic, profile
test/state_test.dart     unit tests for the logic
```

## Next steps
- Replace the drawn cat illustrations with your real assets (add an `assets/` folder + pubspec entry).
- Swap `data.dart` for a real backend (Firebase / Supabase / REST) and real authentication.

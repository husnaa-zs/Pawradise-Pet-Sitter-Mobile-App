import 'package:flutter/widgets.dart';

import 'data.dart';

enum Role { owner, sitter }

/// Single source of truth for the whole app (a simple ChangeNotifier).
class AppState extends ChangeNotifier {
  Role role = Role.owner;
  bool loggedIn = false;
  String name = 'Husna', bio = '', phone = '', email = '', city = '';

  final Set<String> favorites = {};
  final List<Booking> bookings = [];
  final List<Appointment> appointments = [];
  final List<AdoptionRequest> adoptionRequests = [];
  final List<SitterRequest> incoming = [
    SitterRequest(owner: 'Aina', cat: 'Mochi', when: 'Sat, 10:00'),
    SitterRequest(owner: 'Farid', cat: 'Simba', when: 'Sun, 14:00'),
    SitterRequest(owner: 'Mei Ling', cat: 'Bella', when: 'Mon, 09:00'),
  ];

  void setRole(Role r) {
    role = r;
    notifyListeners();
  }

  /// Mock authentication: accepts any non-empty email.
  void login(String emailInput, {String? displayName}) {
    email = emailInput;
    if (displayName != null && displayName.isNotEmpty) name = displayName;
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }

  void updateProfile({required String name, required String bio, required String phone, required String email, required String city}) {
    this.name = name;
    this.bio = bio;
    this.phone = phone;
    this.email = email;
    this.city = city;
    notifyListeners();
  }

  void toggleFavorite(String catId) {
    favorites.contains(catId) ? favorites.remove(catId) : favorites.add(catId);
    notifyListeners();
  }

  void addBooking(Booking b) {
    bookings.insert(0, b);
    notifyListeners();
  }

  void addAppointment(Appointment a) {
    appointments.insert(0, a);
    notifyListeners();
  }

  bool hasRequested(Cat c) => adoptionRequests.any((r) => r.cat.id == c.id);

  void requestAdoption(Cat c) {
    if (hasRequested(c)) return;
    adoptionRequests.insert(0, AdoptionRequest(cat: c, date: DateTime.now()));
    notifyListeners();
  }

  void respond(SitterRequest r, String status) {
    r.status = status;
    notifyListeners();
  }
}

/// Makes AppState available anywhere: AppScope.of(context).
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);

  static AppState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

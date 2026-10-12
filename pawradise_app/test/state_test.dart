import 'package:flutter_test/flutter_test.dart';
import 'package:pawradise/data.dart';
import 'package:pawradise/state.dart';

void main() {
  test('booking total sums selected services', () {
    final b = Booking(sitter: sitters[0], date: DateTime(2026, 10, 12), services: [kServices[0], kServices[1]]);
    expect(b.total, 45);
  });

  test('state records bookings, favourites and adoption requests', () {
    final s = AppState();
    s.toggleFavorite('c1');
    expect(s.favorites.contains('c1'), true);
    s.requestAdoption(cats[0]);
    s.requestAdoption(cats[0]); // duplicate ignored
    expect(s.adoptionRequests.length, 1);
    s.addBooking(Booking(sitter: sitters[0], date: DateTime.now(), services: [kServices[2]]));
    expect(s.bookings.length, 1);
  });
}

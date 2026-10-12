/// ---------- Models + mock data (stands in for a backend) ----------

class Service {
  final String name;
  final int price;
  const Service(this.name, this.price);
}

const kServices = [
  Service('Feeding & Fresh Water', 30),
  Service('Litter Box Cleaning', 15),
  Service('Grooming', 20),
  Service('Emergency Vet Support', 45),
  Service('House Sitting Extras', 20),
  Service('Special Needs Care', 30),
];

class Sitter {
  final String id, name, bio, area;
  final double rating;
  final int reviews;
  final bool nearby, available;
  final List<String> reviewTexts;
  const Sitter({
    required this.id,
    required this.name,
    required this.bio,
    required this.area,
    required this.rating,
    required this.reviews,
    required this.nearby,
    required this.available,
    required this.reviewTexts,
  });
}

const sitters = [
  Sitter(id: 's1', name: 'Maya Tan', area: 'Melaka Tengah', rating: 4.9, reviews: 128, nearby: true, available: true,
      bio: 'Cat lover with 5 years of experience. Comfortable with senior and special-needs cats.',
      reviewTexts: ['Mochi was so relaxed when we got home!', 'Sends photo updates every day.']),
  Sitter(id: 's2', name: 'Daniel Lee', area: 'Ayer Keroh', rating: 4.7, reviews: 76, nearby: true, available: false,
      bio: 'Former vet assistant. Can give medication and handle emergencies.',
      reviewTexts: ['Very professional and calm.']),
  Sitter(id: 's3', name: 'Aisha Rahman', area: 'Alor Gajah', rating: 4.8, reviews: 54, nearby: false, available: true,
      bio: 'Home-based sitter with a cat-safe garden. Grooming included.',
      reviewTexts: ['My cat looked brand new after grooming.']),
  Sitter(id: 's4', name: 'Chen Wei', area: 'Jasin', rating: 4.5, reviews: 31, nearby: false, available: true,
      bio: 'Weekend sitter. Flexible hours and house-sitting available.',
      reviewTexts: ['Reliable and kind.']),
];

enum CatBreed { tabby, calico, black, british, siamese, persian, tuxedo }

extension CatBreedName on CatBreed {
  String get label => switch (this) {
        CatBreed.tabby => 'Orange Tabby',
        CatBreed.calico => 'Calico',
        CatBreed.black => 'Black Cat',
        CatBreed.british => 'British Shorthair',
        CatBreed.siamese => 'Siamese',
        CatBreed.persian => 'Persian',
        CatBreed.tuxedo => 'Tuxedo',
      };
}

class Cat {
  final String id, name, info, story;
  final CatBreed breed;
  const Cat({required this.id, required this.name, required this.info, required this.story, required this.breed});
}

const cats = [
  Cat(id: 'c1', name: 'Olivia', info: 'Female, 2 years', breed: CatBreed.tabby, story: 'Playful and loves window watching. Vaccinated and neutered.'),
  Cat(id: 'c2', name: 'Pedro', info: 'Male, 3 years', breed: CatBreed.tuxedo, story: 'Calm lap cat in a tiny tuxedo. Good with children.'),
  Cat(id: 'c3', name: 'Mochi', info: 'Female, 4 months', breed: CatBreed.siamese, story: 'Tiny, chatty and curious. Needs a patient first-time owner.'),
  Cat(id: 'c4', name: 'Patches', info: 'Female, 2 years', breed: CatBreed.calico, story: 'Spirited calico who loves to be the centre of attention.'),
  Cat(id: 'c5', name: 'Luna', info: 'Female, 2 years', breed: CatBreed.persian, story: 'Gentle Persian. Needs regular grooming and a calm home.'),
  Cat(id: 'c6', name: 'Oreo', info: 'Male, 1 year', breed: CatBreed.black, story: 'Shy at first, then very affectionate.'),
  Cat(id: 'c7', name: 'Bella', info: 'Female, 1 year', breed: CatBreed.british, story: 'Round, fluffy and relaxed. Loves snacks and naps.'),
  Cat(id: 'c8', name: 'Tiger', info: 'Male, 6 months', breed: CatBreed.tabby, story: 'Energetic kitten. Will need lots of toys!'),
];

class Doctor {
  final String name;
  final double rating;
  final int reviews;
  final List<String> slots;
  final Set<String> booked;
  const Doctor({required this.name, required this.rating, required this.reviews, required this.slots, required this.booked});
}

const doctors = [
  Doctor(name: 'Dr. Sarah Lim', rating: 4.9, reviews: 37,
      slots: ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '12:00', '13:00'], booked: {'09:30', '11:30'}),
  Doctor(name: 'Dr. Amir Hassan', rating: 4.8, reviews: 52,
      slots: ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '12:00', '13:00'], booked: {'10:00'}),
];

/// ---------- Records created by the user (kept in AppState) ----------

class Booking {
  final Sitter sitter;
  final DateTime date;
  final List<Service> services;
  Booking({required this.sitter, required this.date, required this.services});
  int get total => services.fold(0, (sum, s) => sum + s.price);
}

class Appointment {
  final Doctor doctor;
  final DateTime date;
  final String time;
  Appointment({required this.doctor, required this.date, required this.time});
}

class AdoptionRequest {
  final Cat cat;
  final DateTime date;
  AdoptionRequest({required this.cat, required this.date});
}

/// Incoming job request shown to users who chose the "sitter" role.
class SitterRequest {
  final String owner, cat, when;
  String status;
  SitterRequest({required this.owner, required this.cat, required this.when, this.status = 'Pending'});
}

const _dow = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _mon = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
String fmtDate(DateTime d) => '${_dow[d.weekday - 1]}, ${d.day} ${_mon[d.month - 1]}';
String dowShort(DateTime d) => _dow[d.weekday - 1];
String monShort(DateTime d) => _mon[d.month - 1].toUpperCase();

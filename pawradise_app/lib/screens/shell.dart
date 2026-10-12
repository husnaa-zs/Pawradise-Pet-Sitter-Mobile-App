import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'adoption.dart';
import 'clinic.dart';
import 'profile.dart';
import 'sitters.dart';

/// Main app frame: bottom navigation with 5 tabs.
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: [
        HomeTab(onGo: (i) => setState(() => _index = i)),
        const SittersScreen(),
        const AdoptionScreen(),
        const ClinicScreen(),
        const ProfileScreen(),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.pets_outlined), selectedIcon: Icon(Icons.pets), label: 'Sitters'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Adopt'),
          NavigationDestination(icon: Icon(Icons.local_hospital_outlined), selectedIcon: Icon(Icons.local_hospital), label: 'Clinic'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final void Function(int) onGo;
  const HomeTab({super.key, required this.onGo});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final isSitter = s.role == Role.sitter;
    final categories = <(String, IconData, VoidCallback)>[
      ('Vet', Icons.local_hospital, () => onGo(3)),
      ('Grooming', Icons.content_cut, () => onGo(1)),
      ('Sitter', Icons.pets, () => onGo(1)),
      ('Adopt', Icons.favorite, () => onGo(2)),
      ('Tips', Icons.lightbulb_outline, () => toast(context, 'Cat care tips coming soon')),
    ];
    return Scaffold(
      body: ListView(padding: EdgeInsets.zero, children: [
        Container(
          padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 16, 24, 24),
          decoration: const BoxDecoration(color: AppColors.taupe, borderRadius: BorderRadius.vertical(bottom: Radius.circular(26))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Welcome back,', style: TextStyle(color: Color(0xFFD8D0C0))),
                  Text(s.name, style: headStyle(24, Colors.white)),
                ]),
              ),
              Chip(label: Text(isSitter ? 'Sitter' : 'Owner'), backgroundColor: AppColors.gold, side: BorderSide.none),
            ]),
            const SizedBox(height: 16),
            TextField(
              readOnly: true,
              onTap: () => onGo(1),
              decoration: InputDecoration(
                hintText: 'Search here',
                suffixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('JOIN OUR\nCAT LOVER COMMUNITY', style: headStyle(14)),
                    const SizedBox(height: 4),
                    const Text('Connect. Care. Cuddle.', style: TextStyle(fontSize: 11, color: AppColors.brown)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => toast(context, 'Welcome to the community!'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.charcoal, elevation: 0, shape: const StadiumBorder()),
                      child: const Text('Join now', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ]),
                ),
                const PixelCat(breed: CatBreed.tabby, pose: 'sit', width: 110),
              ]),
            ),
            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              for (final c in categories)
                InkWell(
                  onTap: c.$3,
                  borderRadius: BorderRadius.circular(30),
                  child: Column(children: [
                    CircleAvatar(radius: 26, backgroundColor: AppColors.peach, child: Icon(c.$2, color: AppColors.brown)),
                    const SizedBox(height: 6),
                    Text(c.$1, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  ]),
                ),
            ]),
            const SizedBox(height: 18),
            Row(children: [
              _Stat('Bookings', s.bookings.length),
              _Stat('Appointments', s.appointments.length),
              _Stat('Adoptions', s.adoptionRequests.length),
            ]),
            const SizedBox(height: 20),
            if (isSitter) ...[
              Text('Booking requests', style: headStyle(16)),
              const SizedBox(height: 10),
              for (final r in s.incoming)
                Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text('${r.owner} - ${r.cat}', style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text('${r.when}  |  ${r.status}'),
                    trailing: r.status == 'Pending'
                        ? Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () => s.respond(r, 'Accepted')),
                            IconButton(icon: const Icon(Icons.cancel, color: Colors.redAccent), onPressed: () => s.respond(r, 'Declined')),
                          ])
                        : null,
                  ),
                ),
            ] else ...[
              Text('Popular near you', style: headStyle(16)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: .95,
                children: [
                  for (final c in cats.take(4))
                    CatCard(
                      cat: c,
                      favorite: s.favorites.contains(c.id),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CatDetailScreen(cat: c))),
                      onFavorite: () => s.toggleFavorite(c.id),
                    ),
                ],
              ),
            ],
          ]),
        ),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  const _Stat(this.label, this.value);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: AppColors.peach, borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Text('$value', style: headStyle(20)),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}
